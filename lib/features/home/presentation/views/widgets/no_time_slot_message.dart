import 'package:flutter/material.dart';

class NoTimeSlotsMessage extends StatelessWidget {
  final bool isToday;
  final bool hasConflictingAppointments;

  const NoTimeSlotsMessage({
    super.key,
    required this.isToday,
    required this.hasConflictingAppointments,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    String submessage;

    if (isToday && hasConflictingAppointments) {
      message = 'No more available time slots for today';
      submessage = 'You already have appointments during available hours';
    } else if (isToday) {
      message = 'No more available time slots for today';
      submessage = 'Please select tomorrow or another date';
    } else if (hasConflictingAppointments) {
      message = 'You have conflicting appointments on this day';
      submessage = 'Please select another date or check your schedule';
    } else {
      message = 'No available time slots for this day';
      submessage = 'Please select another date';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(
              hasConflictingAppointments ? Icons.event_busy : Icons.event_busy,
              size: 48,
              color: hasConflictingAppointments
                  ? Colors.orange.shade300
                  : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: hasConflictingAppointments
                    ? Colors.orange.shade700
                    : Colors.grey.shade600,
                fontWeight: hasConflictingAppointments
                    ? FontWeight.w500
                    : FontWeight.normal,
                fontStyle: hasConflictingAppointments
                    ? FontStyle.normal
                    : FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              submessage,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
