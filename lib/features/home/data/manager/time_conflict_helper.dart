// features/specialists/utils/time_conflict_helper.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A utility class to help identify time conflicts across multiple appointments.
/// This centralizes the time conflict logic for reuse across the app.
class TimeConflictHelper {
  static final DateFormat _timeFormat = DateFormat('hh:mm a');

  /// Checks if a proposed time slot conflicts with any existing appointments
  static bool hasConflictWithExistingAppointments({
    required DateTime date,
    required String timeSlot,
    required List<AppointmentModel> existingAppointments,
  }) {
    // Only check conflicts for active appointments
    final activeAppointments = existingAppointments
        .where((appointment) => appointment.status == 'scheduled')
        .toList();

    if (activeAppointments.isEmpty) return false;

    // Parse time slot
    final timeRange = timeSlot.split(' - ');
    if (timeRange.length != 2) return false;

    final slotStartTime = _parseTimeString(timeRange[0]);
    final slotEndTime = _parseTimeString(timeRange[1]);

    if (slotStartTime == null || slotEndTime == null) return false;

    // Create full DateTime objects for potential appointment
    final slotStartDateTime = DateTime(date.year, date.month, date.day,
        slotStartTime.hour, slotStartTime.minute);
    final slotEndDateTime = DateTime(
        date.year, date.month, date.day, slotEndTime.hour, slotEndTime.minute);

    // Check for overlaps with existing appointments
    for (final appointment in activeAppointments) {
      if (DateUtils.isSameDay(appointment.appointmentDate, date)) {
        try {
          // Parse the appointment time slot
          final appointmentTimeRange = appointment.timeSlot.split(' - ');
          if (appointmentTimeRange.length != 2) continue;

          final appointmentStartTime =
              _parseTimeString(appointmentTimeRange[0]);
          final appointmentEndTime = _parseTimeString(appointmentTimeRange[1]);

          if (appointmentStartTime == null || appointmentEndTime == null)
            continue;

          // Create DateTime objects for existing appointment
          final appointmentStartDateTime = DateTime(date.year, date.month,
              date.day, appointmentStartTime.hour, appointmentStartTime.minute);
          final appointmentEndDateTime = DateTime(date.year, date.month,
              date.day, appointmentEndTime.hour, appointmentEndTime.minute);

          // Check for overlap
          if ((slotStartDateTime.isBefore(appointmentEndDateTime) ||
                  slotStartDateTime.isAtSameMomentAs(appointmentEndDateTime)) &&
              (slotEndDateTime.isAfter(appointmentStartDateTime) ||
                  slotEndDateTime.isAtSameMomentAs(appointmentStartDateTime))) {
            return true; // Overlap detected
          }
        } catch (e) {
          debugPrint('Error parsing appointment time: $e');
        }
      }
    }

    return false;
  }

  /// Checks if a user already has an appointment with a specific specialist
  static bool hasExistingAppointmentWithSpecialist({
    required String specialistId,
    required List<AppointmentModel> userAppointments,
  }) {
    return userAppointments.any((appointment) =>
        appointment.specialistId == specialistId &&
        appointment.status == 'scheduled');
  }

  /// Helper to parse time string to TimeOfDay
  static TimeOfDay? _parseTimeString(String timeString) {
    try {
      final dateTime = _timeFormat.parse(timeString);
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } catch (e) {
      try {
        final dateTime = DateFormat('H:mm').parse(timeString);
        return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      } catch (e) {
        return null;
      }
    }
  }

  /// Generates available time slots for a day based on specialist availability and user appointments
  static List<String> generateAvailableTimeSlots({
    required DateTime date,
    required String startTime,
    required String endTime,
    required List<AppointmentModel> userAppointments,
  }) {
    // Generate all possible time slots
    final allTimeSlots = generateTimeSlots(startTime, endTime);

    // Filter slots for today
    List<String> filteredSlots = allTimeSlots;
    if (DateUtils.isSameDay(date, DateTime.now())) {
      final now = DateTime.now();
      filteredSlots = allTimeSlots.where((timeSlot) {
        try {
          final startTimeString = timeSlot.split(' - ')[0];
          final slotDateTime = _parseTimeToDate(startTimeString, date);
          return slotDateTime.isAfter(now.add(const Duration(minutes: 30)));
        } catch (e) {
          return false;
        }
      }).toList();
    }

    // Filter out slots with conflicts with any existing appointments
    return filteredSlots.where((timeSlot) {
      return !hasConflictWithExistingAppointments(
        date: date,
        timeSlot: timeSlot,
        existingAppointments: userAppointments,
      );
    }).toList();
  }

  /// Helper to parse a time string to a specific date
  static DateTime _parseTimeToDate(String timeString, DateTime date) {
    final time = _timeFormat.parse(timeString);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Generate time slots from start time to end time
  static List<String> generateTimeSlots(String startTime, String endTime) {
    DateTime start;
    DateTime end;

    try {
      start = _timeFormat.parse(startTime);
      end = _timeFormat.parse(endTime);
    } catch (e) {
      try {
        start = DateFormat('H:mm').parse(startTime);
        end = DateFormat('H:mm').parse(endTime);
      } catch (e) {
        start = DateTime(2022, 1, 1, 9, 0);
        end = DateTime(2022, 1, 1, 17, 0);
      }
    }

    final List<String> slots = [];
    DateTime current = start;

    while (current.isBefore(end)) {
      final slotEnd = current.add(const Duration(hours: 1));
      final slotText =
          '${_timeFormat.format(current)} - ${_timeFormat.format(slotEnd)}';
      slots.add(slotText);
      current = slotEnd;
    }

    return slots;
  }
}
