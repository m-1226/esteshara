// features/appointments/presentation/widgets/specialist_info_widget.dart
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpecialistInfoWidget extends StatelessWidget {
  final SpecialistModel specialist;
  final double avatarRadius;
  final double nameSize;
  final double specializationSize;

  const SpecialistInfoWidget({
    super.key,
    required this.specialist,
    this.avatarRadius = 25,
    this.nameSize = 16,
    this.specializationSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    // Using IntrinsicWidth to provide width constraints
    return IntrinsicWidth(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Flexible(
            // Use Flexible instead of Expanded
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  specialist.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: nameSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  specialist.specialization,
                  style: TextStyle(
                    color: _getSpecializationColor(specialist.specialization),
                    fontSize: specializationSize,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: specialist.photoUrl.isEmpty
              ? _getSpecializationColor(specialist.specialization)
                  .withOpacity(0.2)
              : Colors.grey.shade200,
          backgroundImage: specialist.photoUrl.isNotEmpty
              ? NetworkImage(specialist.photoUrl)
              : null,
          child: specialist.photoUrl.isEmpty
              ? Text(
                  specialist.name.isNotEmpty
                      ? specialist.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    fontSize: avatarRadius * 0.8,
                    fontWeight: FontWeight.bold,
                    color: _getSpecializationColor(specialist.specialization),
                  ),
                )
              : null,
        ),

        // Available indicator
        if (_isAvailableNow(specialist))
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: avatarRadius * 0.7,
              height: avatarRadius * 0.7,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  bool _isAvailableNow(SpecialistModel specialist) {
    // Get current day name (e.g., "Monday")
    final now = DateTime.now();
    final currentDay = _getDayName(now.weekday);

    // Check if specialist is available today
    final isAvailableToday =
        specialist.availableTimes.any((time) => time.day == currentDay);

    if (!isAvailableToday) return false;

    // Check if current time is within availability hours
    final availabilityTime = specialist.availableTimes.firstWhere(
      (time) => time.day == currentDay,
    );

    try {
      // Parse times (could be in various formats)
      late DateTime startTime;
      late DateTime endTime;

      // Try to parse as "9:00 AM" format
      try {
        startTime = DateFormat('h:mm a').parse(availabilityTime.startTime);
        endTime = DateFormat('h:mm a').parse(availabilityTime.endTime);
      } catch (e) {
        // Try to parse as "9:00" format (24-hour)
        try {
          startTime = DateFormat('H:mm').parse(availabilityTime.startTime);
          endTime = DateFormat('H:mm').parse(availabilityTime.endTime);
        } catch (e) {
          // Default fallback - assume not available
          return false;
        }
      }

      // Set to today's date for comparison
      final currentTimeOfDay =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);

      final todayStartTime = DateTime(
          now.year, now.month, now.day, startTime.hour, startTime.minute);

      final todayEndTime =
          DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

      return currentTimeOfDay.isAfter(todayStartTime) &&
          currentTimeOfDay.isBefore(todayEndTime);
    } catch (e) {
      return false;
    }
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

  Color _getSpecializationColor(String specialization) {
    final Map<String, Color> specializationColors = {
      'Cardiologist': Colors.red.shade400,
      'Dermatologist': Colors.purple.shade400,
      'Pediatrician': Colors.green.shade400,
      'Business Consultant': Colors.blue.shade400,
      'Career Coach': Colors.orange.shade400,
      'Neurologist': Colors.indigo.shade400,
      'Psychiatrist': Colors.pink.shade400,
    };

    return specializationColors[specialization] ?? Colors.blue.shade600;
  }
}

class SpecialistLoading extends StatelessWidget {
  final double avatarRadius;

  const SpecialistLoading({
    super.key,
    this.avatarRadius = 25,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated shimmer effect for avatar
          Container(
            width: avatarRadius * 2,
            height: avatarRadius * 2,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: avatarRadius * 1.2,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 18,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
