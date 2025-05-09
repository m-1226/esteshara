import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SpecialistHighlightItem extends StatelessWidget {
  final String title;
  final String value;

  const SpecialistHighlightItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: AppStyles.regular14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyles.regular16.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
