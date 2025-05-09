import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_app_bar.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_highlight_item.dart'
    show SpecialistHighlightItem;
import 'package:esteshara/features/home/presentation/views/widgets/specialist_info_row.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_price_card.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_stats_row.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_tabs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpecialistDetailsViewBody extends StatelessWidget {
  final SpecialistModel specialist;

  const SpecialistDetailsViewBody({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SpecialistAppBar(specialist: specialist),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpecialistStatsRow(specialist: specialist),
                const SizedBox(height: 16),
                SpecialistInfoRow(
                  icon: Icons.access_time,
                  text: _getAvailabilityText(),
                ),
                const SizedBox(height: 8),
                const SpecialistInfoRow(
                  icon: Icons.location_on_outlined,
                  text: 'Cairo, Egypt',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SpecialistPriceCard(
                        title: '${specialist.price.toInt()} EGP',
                        subtitle: 'Consultation Fee',
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: SpecialistPriceCard(
                        title: '30 min',
                        subtitle: 'Session Duration',
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Highlights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SpecialistHighlightItem(
                  title: 'Specialized in',
                  value: _getSpecializationHighlight(),
                ),
                const SpecialistHighlightItem(
                  title: 'Languages',
                  value: 'Arabic, English',
                ),
                const SpecialistHighlightItem(
                  title: 'Available for',
                  value: 'Online Consultation, Video Call',
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: SpecialistTabs(specialist: specialist),
        ),
        // Add space at the bottom for the floating action button
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
        ),
      ],
    );
  }

  String _getAvailabilityText() {
    final today = DateTime.now();
    final todayName = DateFormat('EEEE').format(today);

    final isAvailableToday =
        specialist.availableTimes.any((time) => time.day == todayName);

    if (isAvailableToday) {
      final time =
          specialist.availableTimes.firstWhere((time) => time.day == todayName);
      return 'Available today: ${time.startTime} - ${time.endTime}';
    } else {
      // Find next available day
      final dayOrder = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      final todayIndex = dayOrder.indexOf(todayName);

      for (int i = 1; i <= 7; i++) {
        final nextDayIndex = (todayIndex + i) % 7;
        final nextDay = dayOrder[nextDayIndex];

        final isAvailable =
            specialist.availableTimes.any((time) => time.day == nextDay);
        if (isAvailable) {
          return 'Next available: $nextDay';
        }
      }

      return 'Currently unavailable';
    }
  }

  String _getSpecializationHighlight() {
    final Map<String, String> specializationHighlights = {
      'Cardiologist': 'Heart diseases, Hypertension, Cardiac arrhythmias',
      'Dermatologist': 'Skin disorders, Hair loss, Cosmetic procedures',
      'Pediatrician': 'Child healthcare, Development assessment, Vaccinations',
      'Business Consultant': 'Business Strategy, Marketing, Financial Analysis',
      'Career Coach':
          'Career Development, Interview Preparation, Resume Building',
      'Neurologist': 'Brain disorders, Stroke, Epilepsy, Headaches',
      'Psychiatrist': 'Mental health, Anxiety, Depression, PTSD',
    };

    return specializationHighlights[specialist.specialization] ??
        'General consultation';
  }
}
