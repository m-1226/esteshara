// features/specialists/presentation/views/widgets/specialists_view_body.dart
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
import 'package:esteshara/features/specialists/presentation/views/widgets/specialist_card.dart';
import 'package:flutter/material.dart';

class SpecialistsViewBody extends StatelessWidget {
  final List<SpecialistModel> specialists;

  const SpecialistsViewBody({
    super.key,
    required this.specialists,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        final specialist = specialists[index];
        return SpecialistCard(
          specialist: specialist,
          onTap: () {
            // Navigate to specialist detail page
            // For now, just show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected: ${specialist.name}')),
            );
          },
        );
      },
    );
  }
}
