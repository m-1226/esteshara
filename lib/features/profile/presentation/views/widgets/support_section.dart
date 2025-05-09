import 'package:flutter/material.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/custom_profile_list_tile.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
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
}
