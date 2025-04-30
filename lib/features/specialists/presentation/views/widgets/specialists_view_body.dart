import 'package:esteshara/features/specialists/presentation/views/widgets/specialist_card.dart';
import 'package:flutter/material.dart';

class SpecialistsViewBody extends StatelessWidget {
  const SpecialistsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for specialists
    final specialists = [
      {
        'name': 'Dr. Ahmed Hassan',
        'specialization': 'Cardiologist',
        'bio':
            'Experienced cardiologist with 10+ years of practice in treating heart conditions.',
        'availableDays': ['Monday', 'Wednesday', 'Friday'],
      },
      {
        'name': 'Dr. Sara Mahmoud',
        'specialization': 'Dermatologist',
        'bio':
            'Specialist in skin conditions and cosmetic dermatology with a focus on holistic treatment approaches.',
        'availableDays': ['Tuesday', 'Thursday', 'Saturday'],
      },
      {
        'name': 'Dr. Khaled Omar',
        'specialization': 'Business Consultant',
        'bio':
            'Strategic business advisor helping companies optimize their operations and increase profitability.',
        'availableDays': ['Monday', 'Tuesday', 'Wednesday'],
      },
      {
        'name': 'Dr. Laila Farid',
        'specialization': 'Pediatrician',
        'bio':
            'Caring pediatrician dedicated to the health and wellbeing of children from infancy through adolescence.',
        'availableDays': ['Sunday', 'Wednesday', 'Thursday'],
      },
      {
        'name': 'Dr. Omar Nabil',
        'specialization': 'Career Coach',
        'bio':
            'Professional career advisor with expertise in helping professionals navigate career transitions and growth.',
        'availableDays': ['Monday', 'Friday', 'Sunday'],
      },
    ];
    return ListView.builder(
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        final specialist = specialists[index];
        return SpecialistCard(
          name: specialist['name'] as String,
          specialization: specialist['specialization'] as String,
          bio: specialist['bio'] as String,
          availableDays: specialist['availableDays'] as List<String>,
          onTap: () {
            // For now, just show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected: ${specialist['name']}')),
            );
          },
        );
      },
    );
  }
}
