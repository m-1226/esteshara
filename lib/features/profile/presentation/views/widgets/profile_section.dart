import 'package:flutter/material.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/custom_profile_list_tile.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
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
}
