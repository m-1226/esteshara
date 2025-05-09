import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_details_avatar.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specializtion_badge.dart';
import 'package:flutter/material.dart';

class SpecialistInfo extends StatelessWidget {
  final SpecialistModel specialist;
  final Color specializationColor;

  const SpecialistInfo({
    super.key,
    required this.specialist,
    required this.specializationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Row(
        children: [
          SpecialistDetailsAvatar(
            name: specialist.name,
            photoUrl: specialist.photoUrl,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                specialist.name,
                style: AppStyles.notoKufiWhiteStyle18.copyWith(
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              SpecializationBadge(
                specialization: specialist.specialization,
                specializationColor: specializationColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
