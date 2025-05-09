import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/appointments_section.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/profile_app_bar.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/profile_data_loader.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/profile_section.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/profile_stats_section.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/section_title.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/sign_out_button.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/support_section.dart';
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

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _firebaseService.currentUser;

    if (currentUser == null) {
      _redirectToLogin();
      return const Center(child: CircularProgressIndicator());
    }

    return ProfileDataLoader(
      userId: currentUser.uid,
      builder: (context, userModel, isLoading, error) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null) {
          return _buildErrorView(error);
        }

        if (userModel == null) {
          return const Center(child: Text('User profile not found'));
        }

        return CustomScrollView(
          slivers: [
            ProfileAppBar(
              userModel: userModel,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ProfileStatsSection(userModel: userModel),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Profile'),
                  const ProfileSection(),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Appointments'),
                  AppointmentsSection(context: context),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Support'),
                  const SupportSection(),
                  const SizedBox(height: 24),
                  SignOutButton(),
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

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRouters.kLoginView);
    });
  }

  Widget _buildErrorView(String error) {
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
}
