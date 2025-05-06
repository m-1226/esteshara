// features/home/presentation/widgets/category_selector.dart
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
      builder: (context, state) {
        if (state is! SpecialistsLoaded) {
          return const SizedBox(height: 100);
        }

        // Extract unique specializations
        final specializations = _getUniqueSpecializations(state.specialists);

        return Container(
          height: 100,
          margin: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: specializations.length + 1, // +1 for "All" category
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" category
                return CategoryItem(
                  icon: Icons.apps,
                  label: 'All',
                  isSelected: selectedCategory == null,
                  onTap: () => onCategorySelected(null),
                );
              }

              final specialization = specializations[index - 1];
              return CategoryItem(
                icon: _getSpecializationIcon(specialization),
                label: _getShortenedLabel(specialization),
                isSelected: selectedCategory == specialization,
                onTap: () => _toggleSpecialization(specialization),
              );
            },
          ),
        );
      },
    );
  }

  List<String> _getUniqueSpecializations(List<SpecialistModel> specialists) {
    final Set<String> uniqueSpecializations = {};
    for (var specialist in specialists) {
      uniqueSpecializations.add(specialist.specialization);
    }
    return uniqueSpecializations.toList()..sort();
  }

  IconData _getSpecializationIcon(String specialization) {
    final Map<String, IconData> specializationIcons = {
      'Cardiologist': Icons.favorite,
      'Dermatologist': Icons.face,
      'Pediatrician': Icons.child_care,
      'Business Consultant': Icons.business,
      'Career Coach': Icons.work,
      'Neurologist': Icons.psychology,
      'Psychiatrist': Icons.sentiment_satisfied_alt,
    };

    return specializationIcons[specialization] ?? Icons.medical_services;
  }

  String _getShortenedLabel(String specialization) {
    return specialization.replaceAll('ist', ''); // Shorter labels
  }

  void _toggleSpecialization(String specialization) {
    if (selectedCategory == specialization) {
      onCategorySelected(null);
    } else {
      onCategorySelected(specialization);
    }
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getSpecializationColor(context, label);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getSpecializationColor(BuildContext context, String specialization) {
    final Map<String, Color> specializationColors = {
      'All': Colors.blue.shade600,
      'Cardiologist': Colors.red.shade400,
      'Cardio': Colors.red.shade400,
      'Dermatologist': Colors.purple.shade400,
      'Dermato': Colors.purple.shade400,
      'Pediatrician': Colors.green.shade400,
      'Pediatr': Colors.green.shade400,
      'Business Consultant': Colors.blue.shade400,
      'Business': Colors.blue.shade400,
      'Career Coach': Colors.orange.shade400,
      'Career': Colors.orange.shade400,
      'Neurologist': Colors.indigo.shade400,
      'Neuro': Colors.indigo.shade400,
      'Psychiatrist': Colors.pink.shade400,
      'Psych': Colors.pink.shade400,
    };

    return specializationColors[specialization] ??
        Theme.of(context).primaryColor;
  }
}
