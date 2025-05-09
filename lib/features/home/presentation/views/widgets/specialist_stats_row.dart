import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:flutter/material.dart';

class SpecialistStatsRow extends StatelessWidget {
  final SpecialistModel specialist;

  const SpecialistStatsRow({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StatItem(
          icon: Icons.star,
          color: Colors.amber,
          title: '${specialist.rating}',
          subtitle: '${specialist.reviewCount} reviews',
        ),
        const StatItem(
          icon: Icons.medical_services_outlined,
          color: Colors.blue,
          title: '5+ years',
          subtitle: 'Experience',
        ),
        const StatItem(
          icon: Icons.people_outline,
          color: Colors.green,
          title: '500+',
          subtitle: 'Patients',
        ),
      ],
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const StatItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppStyles.bold16,
        ),
        Text(
          subtitle,
          style: AppStyles.regular14,
        ),
      ],
    );
  }
}
