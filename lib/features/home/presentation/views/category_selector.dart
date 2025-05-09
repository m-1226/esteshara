// features/home/presentation/widgets/category_selector.dart
import 'package:esteshara/core/utils/app_colors.dart';
import 'package:esteshara/core/utils/app_styles.dart';
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
          return const SizedBox(height: 120);
        }

        // Extract unique specializations
        final specializations = _getUniqueSpecializations(state.specialists);

        return Container(
          height: 120,
          margin: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: specializations.length + 1, // +1 for "All" category
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" category
                return CategoryItemCard(
                  specialization: 'All',
                  isSelected: selectedCategory == null,
                  onTap: () => onCategorySelected(null),
                );
              }

              final specialization = specializations[index - 1];
              return CategoryItemCard(
                specialization: specialization,
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

  void _toggleSpecialization(String specialization) {
    if (selectedCategory == specialization) {
      onCategorySelected(null);
    } else {
      onCategorySelected(specialization);
    }
  }
}

class CategoryItemCard extends StatelessWidget {
  final String specialization;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItemCard({
    super.key,
    required this.specialization,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.specializationColors[specialization] ??
        (specialization == 'All'
            ? Colors.blue.shade600
            : Theme.of(context).primaryColor);

    final iconUrl = _getSpecializationImageUrl(specialization);
    final displayName = _getDisplayName(specialization);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.95) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: isSelected ? 1 : 0,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container with circular background
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: iconUrl != null
                  ? Image.network(
                      iconUrl,
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        _getSpecializationIcon(specialization),
                        color: isSelected ? color : color,
                        size: 28,
                      ),
                    )
                  : Icon(
                      _getSpecializationIcon(specialization),
                      color: isSelected ? color : color,
                      size: 28,
                    ),
            ),
            const SizedBox(height: 12),
            // Category name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                displayName,
                style: AppStyles.bold14.copyWith(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayName(String specialization) {
    if (specialization == 'All') {
      return 'All Specialists';
    }

    // Simplified names for common long specializations
    final Map<String, String> displayNames = {
      'Cardiologist': 'Heart',
      'Dermatologist': 'Skin',
      'Pediatrician': 'Child Care',
      'Business Consultant': 'Business',
      'Career Coach': 'Career',
      'Neurologist': 'Neurology',
      'Psychiatrist': 'Psychiatry',
    };

    return displayNames[specialization] ?? specialization;
  }

  IconData _getSpecializationIcon(String specialization) {
    final Map<String, IconData> specializationIcons = {
      'All': Icons.category_rounded,
      'Cardiologist': Icons.favorite_rounded,
      'Dermatologist': Icons.face_retouching_natural,
      'Pediatrician': Icons.child_friendly_rounded,
      'Business Consultant': Icons.business_center_rounded,
      'Career Coach': Icons.trending_up_rounded,
      'Neurologist': Icons.psychology_rounded,
      'Psychiatrist': Icons.sentiment_satisfied_alt_rounded,
      'Ophthalmologist': Icons.visibility_rounded,
      'Dentist': Icons.emoji_emotions_rounded,
      'Gynecologist': Icons.pregnant_woman_rounded,
      'Orthopedic': Icons.wheelchair_pickup_rounded,
    };

    return specializationIcons[specialization] ??
        Icons.medical_services_rounded;
  }

  String? _getSpecializationImageUrl(String specialization) {
    // SVG icons would be better, but for demonstration let's use some placeholder URLs
    // In a real app, these would be hosted on your servers or CDN
    final Map<String, String> imageUrls = {
      'Cardiologist': 'https://cdn-icons-png.flaticon.com/512/2966/2966327.png',
      'Dermatologist':
          'https://cdn-icons-png.flaticon.com/512/2491/2491418.png',
      'Pediatrician': 'https://cdn-icons-png.flaticon.com/512/2966/2966486.png',
      'Business Consultant':
          'https://cdn-icons-png.flaticon.com/512/1006/1006555.png',
      'Career Coach': 'https://cdn-icons-png.flaticon.com/512/3588/3588658.png',
      'Neurologist': 'https://cdn-icons-png.flaticon.com/512/2966/2966486.png',
      'Psychiatrist': 'https://cdn-icons-png.flaticon.com/512/4616/4616734.png',
    };

    // Return null for types without a specific image, will use icon instead
    return imageUrls[specialization];
  }
}
