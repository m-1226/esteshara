import 'package:esteshara/core/utils/app_colors.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/action_button.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_background_image.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_info.dart';
import 'package:flutter/material.dart';

class SpecialistAppBar extends StatelessWidget {
  final SpecialistModel specialist;

  const SpecialistAppBar({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    final Color specializationColor =
        AppColors.specializationColors[specialist.specialization] ??
            Colors.blue.shade600;

    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'specialist_${specialist.id}',
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  specializationColor.withOpacity(0.8),
                  specializationColor.withOpacity(0.4),
                ],
              ),
            ),
            child: Stack(
              children: [
                SpecialistBackgroundImage(photoUrl: specialist.photoUrl),
                SpecialistInfo(
                  specialist: specialist,
                  specializationColor: specializationColor,
                ),
              ],
            ),
          ),
        ),
      ),
      leading: BackButton(onPressed: () => Navigator.pop(context)),
      actions: [
        ActionButton(
          icon: Icons.favorite_border,
          color: Colors.red,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to favorites'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        ActionButton(
          icon: Icons.share,
          color: Colors.black87,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Share profile'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
