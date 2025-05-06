import 'package:esteshara/features/home/presentation/views/widgets/custom_chip.dart';
import 'package:flutter/material.dart';

class ExperienceChips extends StatelessWidget {
  const ExperienceChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        CustomChip(label: '5+ yrs'),
        CustomChip(label: '98% success'),
      ],
    );
  }
}
