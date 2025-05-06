// features/home/presentation/widgets/specialists_list.dart
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_card.dart';
import 'package:flutter/material.dart';

class SpecialistsList extends StatelessWidget {
  final List<SpecialistModel> specialists;
  final Function(SpecialistModel) onSpecialistTap;

  const SpecialistsList({
    super.key,
    required this.specialists,
    required this.onSpecialistTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        final specialist = specialists[index];
        return SpecialistCard(
          specialist: specialist,
          onTap: () => onSpecialistTap(specialist),
        );
      },
    );
  }
}
