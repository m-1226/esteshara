import 'package:esteshara/features/appointments/presentation/views/widgets/time_slot_widget.dart';
import 'package:esteshara/features/home/presentation/views/widgets/no_time_slot_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSelectionSection extends StatelessWidget {
  final DateTime selectedDate;
  final List<String> availableTimeSlots;
  final String? selectedTimeSlot;
  final Function(String) onTimeSelected;
  final Function(DateTime) hasConflicts;

  const TimeSelectionSection({
    super.key,
    required this.selectedDate,
    required this.availableTimeSlots,
    required this.selectedTimeSlot,
    required this.onTimeSelected,
    required this.hasConflicts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeSelectionHeader(context),
        const SizedBox(height: 8),
        if (availableTimeSlots.isNotEmpty) _buildWorkingHoursInfo(context),
        availableTimeSlots.isEmpty
            ? NoTimeSlotsMessage(
                isToday: DateUtils.isSameDay(selectedDate, DateTime.now()),
                hasConflictingAppointments: hasConflicts(selectedDate),
              )
            : _buildTimeSlots(),
      ],
    );
  }

  Widget _buildTimeSelectionHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Select Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            DateFormat('EEEE, MMM d').format(selectedDate),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkingHoursInfo(BuildContext context) {
    String workingHoursText = "";

    if (availableTimeSlots.isNotEmpty) {
      final firstSlotStart = availableTimeSlots.first.split(' - ')[0];
      final lastSlotEnd = availableTimeSlots.last.split(' - ')[1];
      workingHoursText = '$firstSlotStart - $lastSlotEnd';

      // If today, add note about filtering
      if (DateUtils.isSameDay(selectedDate, DateTime.now())) {
        workingHoursText += ' (remaining today)';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Available hours: $workingHoursText',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 12,
      runSpacing: 16,
      children: availableTimeSlots.map((time) {
        final isSelected = selectedTimeSlot == time;
        return TimeSlotWidget(
          timeSlot: time,
          isSelected: isSelected,
          onTap: () => onTimeSelected(time),
        );
      }).toList(),
    );
  }
}
