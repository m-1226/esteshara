import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SpecialistPriceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isPrimary;

  const SpecialistPriceCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppStyles.bold18.copyWith(
              color: isPrimary ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: AppStyles.regular14,
          ),
        ],
      ),
    );
  }
}
