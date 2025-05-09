import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String userName;
  final String? profileImageUrl;
  final double radius;
  final bool showCameraIcon;

  const ProfileImage({
    super.key,
    required this.userName,
    this.profileImageUrl,
    this.radius = 40,
    this.showCameraIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildAvatar(context),
        if (showCameraIcon) _buildCameraIcon(context),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white.withOpacity(0.9),
      backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
          ? NetworkImage(profileImageUrl!)
          : null,
      child: profileImageUrl == null || profileImageUrl!.isEmpty
          ? Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : "A",
              style: TextStyle(
                fontSize: radius * 0.9,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            )
          : null,
    );
  }

  Widget _buildCameraIcon(BuildContext context) {
    return Positioned(
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
          size: radius * 0.4,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
