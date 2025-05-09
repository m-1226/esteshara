import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SpecialistInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const SpecialistInfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: AppStyles.regular16.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
