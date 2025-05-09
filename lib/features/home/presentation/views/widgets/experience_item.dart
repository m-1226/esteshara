import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ExperienceItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;

  const ExperienceItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bold16,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppStyles.regular16,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: AppStyles.regular14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
