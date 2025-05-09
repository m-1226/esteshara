import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/working_hour_item.dart';
import 'package:flutter/material.dart';

class SpecialistAboutTab extends StatelessWidget {
  final SpecialistModel specialist;

  const SpecialistAboutTab({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    final dayOrder = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Sort times in correct order
    final sortedTimes = List.of(specialist.availableTimes);
    sortedTimes.sort(
        (a, b) => dayOrder.indexOf(a.day).compareTo(dayOrder.indexOf(b.day)));

    // Get available days for quick lookup
    final availableDays =
        specialist.availableTimes.map((time) => time.day).toSet();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About the Specialist',
            style: AppStyles.bold18,
          ),
          const SizedBox(height: 16),
          Text(
            specialist.bio.isNotEmpty
                ? specialist.bio
                : 'Dr. ${specialist.name} is a highly qualified ${specialist.specialization.toLowerCase()} with several years of experience in the field. They provide personalized care and treatment plans tailored to each patient\'s specific needs. Their approach combines evidence-based medicine with compassionate care to ensure the best possible outcomes for all patients.',
            style: AppStyles.regular16.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Working Hours',
            style: AppStyles.bold18,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dayOrder.length,
            itemBuilder: (context, index) {
              final day = dayOrder[index];
              final isAvailable = availableDays.contains(day);
              final timeSlot = isAvailable
                  ? sortedTimes.firstWhere((time) => time.day == day)
                  : null;

              return WorkingHourItem(
                day: day,
                isAvailable: isAvailable,
                startTime: timeSlot?.startTime,
                endTime: timeSlot?.endTime,
              );
            },
          ),
        ],
      ),
    );
  }
}
