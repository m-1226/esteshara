// features/home/presentation/widgets/specialist_card.dart
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/availability_and_price_row.dart';
import 'package:esteshara/features/home/presentation/views/widgets/experience_chips.dart';
import 'package:esteshara/features/home/presentation/views/widgets/rating_display.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_avatar.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialization_tag.dart';
import 'package:flutter/material.dart';

class SpecialistCard extends StatelessWidget {
  final SpecialistModel specialist;
  final VoidCallback onTap;

  const SpecialistCard({
    super.key,
    required this.specialist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailableToday = _isAvailableToday();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpecialistAvatar(
                photoUrl: specialist.photoUrl,
                name: specialist.name,
                isAvailableToday: isAvailableToday,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialist.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SpecializationTag(
                        specialization: specialist.specialization),
                    const SizedBox(height: 8),
                    RatingDisplay(
                      rating: specialist.rating,
                      reviewCount: specialist.reviewCount,
                    ),
                    const SizedBox(height: 8),
                    AvailabilityAndPriceRow(
                      isAvailableToday: isAvailableToday,
                      price: specialist.price,
                    ),
                    const SizedBox(height: 8),
                    ExperienceChips(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isAvailableToday() {
    final today = DateTime.now();
    final dayName = _getDayName(today.weekday);
    return specialist.availableTimes.any((time) => time.day == dayName);
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}
