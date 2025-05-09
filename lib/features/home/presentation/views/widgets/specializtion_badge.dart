import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SpecializationBadge extends StatelessWidget {
  final String specialization;
  final Color specializationColor;

  const SpecializationBadge({
    super.key,
    required this.specialization,
    required this.specializationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        specialization,
        style: AppStyles.bold14.copyWith(
          color: specializationColor,
        ),
      ),
    );
  }
}
