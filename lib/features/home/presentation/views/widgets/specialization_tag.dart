import 'package:esteshara/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SpecializationTag extends StatelessWidget {
  final String specialization;

  const SpecializationTag({
    super.key,
    required this.specialization,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        AppColors.specializationColors[specialization] ?? Colors.blue.shade600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        specialization,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
