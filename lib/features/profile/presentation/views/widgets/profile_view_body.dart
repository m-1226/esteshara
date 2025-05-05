// features/profile/presentation/views/widgets/profile_view_body.dart
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/custom_profile_list_tile.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/profile_data_loader.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/profile_stats_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  final FirebaseService _firebaseService = getIt<FirebaseService>();
  final AuthRepo _authRepo = getIt<AuthRepo>();

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _firebaseService.currentUser;

    if (currentUser == null) {
      // If not logged in, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRouters.kLoginView);
      });
      return const Center(child: CircularProgressIndicator());
    }

    return ProfileDataLoader(
      userId: currentUser.uid,
      builder: (context, userModel, isLoading, error) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {}); // Refresh the page
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (userModel == null) {
          return const Center(child: Text('User profile not found'));
        }

        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(
                userModel.name, userModel.email, userModel.photoUrl),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildProfileStats(userModel),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Profile'),
                  _buildProfileOptions(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Appointments'),
                  _buildAppointmentOptions(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Support'),
                  _buildSupportOptions(),
                  const SizedBox(height: 24),
                  _buildSignOutButton(context),
                  const SizedBox(height: 32),
                  Text(
                    'App Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSliverAppBar(
      String userName, String userEmail, String? profileImageUrl) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withOpacity(0.8),
                primaryColor,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              _buildProfileImage(userName, profileImageUrl),
              const SizedBox(height: 8),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        titlePadding: EdgeInsets.zero,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () {
            // Navigate to edit profile
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // Navigate to notifications
          },
        ),
      ],
    );
  }

  Widget _buildProfileImage(String userName, String? profileImageUrl) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white.withOpacity(0.9),
          backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
              ? NetworkImage(profileImageUrl)
              : null,
          child: profileImageUrl == null || profileImageUrl.isEmpty
              ? Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : "A",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.camera_alt,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats(dynamic userModel) {
    // Calculate stats from user data
    int completedAppointments = 0;
    int upcomingAppointments = 0;
    double savedMoney = 0.0;

    // Check if appointments field exists and is properly formatted
    if (userModel.appointments != null && userModel.appointments is List) {
      final now = DateTime.now();

      for (var appointment in userModel.appointments) {
        if (appointment.status == 'completed') {
          completedAppointments++;
        } else if (appointment.status == 'scheduled') {
          try {
            final appointmentDate = appointment.appointmentDate;
            if (appointmentDate != null && appointmentDate.isAfter(now)) {
              upcomingAppointments++;
            }
          } catch (e) {
            // Skip if date parsing fails
          }
        }
      }

      // This is just a placeholder calculation for saved money
      // You might want to implement your own logic
      savedMoney = completedAppointments * 50.0;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ProfileStatsCard(
              icon: Icons.check_circle_outline,
              title: 'Completed',
              value: completedAppointments.toString(),
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ProfileStatsCard(
              icon: Icons.calendar_today,
              title: 'Upcoming',
              value: upcomingAppointments.toString(),
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ProfileStatsCard(
              icon: Icons.savings_outlined,
              title: 'Saved',
              value: '${savedMoney.toInt()} EGP',
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(color: Colors.grey.shade300),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        CustomProfileListTile(
          iconData: Icons.person_outline,
          text: 'Personal Information',
          onTap: () {
            // Navigate to personal information screen
          },
        ),
        CustomProfileListTile(
          iconData: Icons.security,
          text: 'Account Security',
          onTap: () {
            // Navigate to account security screen
          },
        ),
        CustomProfileListTile(
          iconData: Icons.payment,
          text: 'Payment Methods',
          onTap: () {
            // Navigate to payment methods screen
          },
        ),
      ],
    );
  }

  Widget _buildAppointmentOptions(BuildContext context) {
    return Column(
      children: [
        CustomProfileListTile(
          iconData: Icons.history,
          text: 'Appointment History',
          onTap: () {
            context.push(AppRouters.kAppointmentsView);
          },
        ),
        CustomProfileListTile(
          iconData: Icons.favorite_border,
          text: 'Favorite Specialists',
          onTap: () {
            // Navigate to favorite specialists screen
          },
        ),
        CustomProfileListTile(
          iconData: Icons.star_border,
          text: 'My Reviews',
          onTap: () {
            // Navigate to my reviews screen
          },
        ),
      ],
    );
  }

  Widget _buildSupportOptions() {
    return Column(
      children: [
        CustomProfileListTile(
          iconData: Icons.help_outline,
          text: 'Help Center',
          onTap: () {
            // Navigate to help center
          },
        ),
        CustomProfileListTile(
          iconData: Icons.chat_bubble_outline,
          text: 'Contact Support',
          onTap: () {
            // Navigate to contact support
          },
        ),
        CustomProfileListTile(
          iconData: Icons.info_outline,
          text: 'About Us',
          onTap: () {
            // Navigate to about us
          },
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          _showSignOutDialog(context);
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.red),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out? You will need to log in again to access your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Implement sign out
              Navigator.pop(context);

              try {
                await _authRepo.signOut();
                context.go(AppRouters.kLoginView);
              } catch (e) {
                // Show error snackbar
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing out: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }
}
