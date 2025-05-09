import 'package:esteshara/core/models/user_model.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/profile_image.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  final UserModel userModel;

  const ProfileAppBar({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
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
              ProfileImage(
                userName: userModel.name,
                profileImageUrl: userModel.photoUrl,
              ),
              const SizedBox(height: 8),
              Text(
                userModel.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userModel.email,
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
}
