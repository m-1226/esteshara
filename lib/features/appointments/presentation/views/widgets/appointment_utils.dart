// features/appointments/utils/appointment_utils.dart
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentUtils {
  /// Get color for appointment status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  /// Get display text for appointment status
  static String getStatusText(String status) {
    switch (status) {
      case 'scheduled':
        return 'Scheduled';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return capitalize(status);
    }
  }

  /// Capitalize first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Check if a specific day is available for the specialist
  static bool isAvailableDay(SpecialistModel specialist, DateTime date) {
    // Get the day name (e.g., "Monday")
    final dayName = DateFormat('EEEE').format(date);

    // Check if this day is in the specialist's available days
    return specialist.availableTimes.any((time) => time.day == dayName);
  }

  /// Generate time slots for specialist on a specific date
  static List<String> generateTimeSlots(
      SpecialistModel specialist, DateTime date) {
    // Get day of week as string (e.g., "Monday", "Tuesday", etc.)
    final dayOfWeek = DateFormat('EEEE').format(date);

    // Find availability for that day
    final availability = specialist.availableTimes
        .where((time) => time.day.toLowerCase() == dayOfWeek.toLowerCase())
        .toList();

    if (availability.isEmpty) {
      return [];
    }

    // Generate time slots for all availability periods
    List<String> allSlots = [];

    for (var availTime in availability) {
      final slots = generateTimeSlotsForPeriod(
        availTime.startTime,
        availTime.endTime,
        date,
      );
      allSlots.addAll(slots);
    }

    return allSlots;
  }

  /// Generate time slots for a specific time period
  static List<String> generateTimeSlotsForPeriod(
    String startTime,
    String endTime,
    DateTime date,
  ) {
    // Parse times (could be in various formats)
    DateTime? start;
    DateTime? end;

    // Try different date formats for parsing
    try {
      // Try to parse as "9:00 AM" format
      start = DateFormat('h:mm a').parse(startTime);
      end = DateFormat('h:mm a').parse(endTime);
    } catch (e) {
      try {
        // Try to parse as "9:00" format (24-hour)
        start = DateFormat('H:mm').parse(startTime);
        end = DateFormat('H:mm').parse(endTime);
      } catch (e) {
        // If still failing, try more formats
        try {
          start = DateFormat('HH:mm').parse(startTime);
          end = DateFormat('HH:mm').parse(endTime);
        } catch (e) {
          // If all fails, use defaults
          start = DateTime(2022, 1, 1, 9, 0);
          end = DateTime(2022, 1, 1, 17, 0);
        }
      }
    }

    final List<String> slots = [];
    DateTime current = start;

    // Add slots in one-hour increments
    while (current.isBefore(end)) {
      final slotEnd = current.add(const Duration(hours: 1));
      final slotText =
          '${DateFormat('h:mm a').format(current)} - ${DateFormat('h:mm a').format(slotEnd)}';
      slots.add(slotText);
      current = slotEnd;
    }

    return slots;
  }

  /// Get the next available date for a specialist
  static DateTime findNextAvailableDay(SpecialistModel specialist) {
    // Get the day names of available times
    final availableDayNames =
        specialist.availableTimes.map((time) => time.day).toList();

    // Start from tomorrow
    DateTime checkDate = DateTime.now().add(const Duration(days: 1));

    // Check up to 14 days ahead
    for (int i = 0; i < 14; i++) {
      // Get the day name (e.g., "Monday")
      final dayName = DateFormat('EEEE').format(checkDate);

      // If this day name is in available days, select it
      if (availableDayNames.contains(dayName)) {
        return checkDate;
      }

      // Try the next day
      checkDate = checkDate.add(const Duration(days: 1));
    }

    // If no available day found, return tomorrow's date as fallback
    return DateTime.now().add(const Duration(days: 1));
  }

  /// Get the first and last time from a list of time slots
  static Map<String, String> getWorkingHoursFromTimeSlots(
      List<String> timeSlots) {
    if (timeSlots.isEmpty) {
      return {'start': '', 'end': ''};
    }

    String firstTime = timeSlots.first.split(' - ')[0];
    String lastTime = timeSlots.last.split(' - ')[1];

    return {'start': firstTime, 'end': lastTime};
  }
}
