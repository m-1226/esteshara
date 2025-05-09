import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/features/home/presentation/views/widgets/experience_item.dart';
import 'package:flutter/material.dart';

class SpecialistExperienceTab extends StatelessWidget {
  const SpecialistExperienceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: AppStyles.bold18,
          ),
          const SizedBox(height: 16),
          ExperienceItem(
            title: 'Cairo University',
            subtitle: 'Bachelor of Medicine, 2015',
            date: '2009 - 2015',
            icon: Icons.school,
          ),
          ExperienceItem(
            title: 'Cairo University',
            subtitle: 'Master\'s Degree in Medicine',
            date: '2015 - 2018',
            icon: Icons.school,
          ),
          const SizedBox(height: 24),
          Text(
            'Work Experience',
            style: AppStyles.bold18,
          ),
          const SizedBox(height: 16),
          ExperienceItem(
            title: 'Cairo International Hospital',
            subtitle: 'Specialist Doctor',
            date: '2018 - Present',
            icon: Icons.work,
          ),
          ExperienceItem(
            title: 'El-Salam Hospital',
            subtitle: 'Resident Doctor',
            date: '2015 - 2018',
            icon: Icons.work,
          ),
          const SizedBox(height: 24),
          Text(
            'Certifications',
            style: AppStyles.bold18,
          ),
          const SizedBox(height: 16),
          ExperienceItem(
            title: 'Egyptian Medical Syndicate',
            subtitle: 'License to Practice Medicine',
            date: '2015',
            icon: Icons.verified,
          ),
          ExperienceItem(
            title: 'American Board of Medical Specialties',
            subtitle: 'Certified Specialist',
            date: '2018',
            icon: Icons.verified,
          ),
        ],
      ),
    );
  }
}
