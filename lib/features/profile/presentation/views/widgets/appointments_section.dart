import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/custom_profile_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppointmentsSection extends StatelessWidget {
  final BuildContext context;

  const AppointmentsSection({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
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
}
