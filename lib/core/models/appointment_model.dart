import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String specialistId;
  final DateTime appointmentDate;
  final String timeSlot;
  final String status; // "scheduled", "completed", "cancelled"
  final DateTime createdAt; // When the appointment was initially booked
  final DateTime? lastModified; // When the appointment was last modified

  AppointmentModel({
    required this.id,
    required this.specialistId,
    required this.appointmentDate,
    required this.timeSlot,
    this.status = "scheduled",
    DateTime? createdAt,
    this.lastModified,
  }) : createdAt = createdAt ?? DateTime.now();

  // Create from Map (for Firestore)
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      specialistId: map['specialistId'] ?? '',
      appointmentDate: (map['appointmentDate'] as Timestamp).toDate(),
      timeSlot: map['timeSlot'] ?? '',
      status: map['status'] ?? 'scheduled',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastModified: map['lastModified'] != null
          ? (map['lastModified'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'specialistId': specialistId,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'timeSlot': timeSlot,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastModified':
          lastModified != null ? Timestamp.fromDate(lastModified!) : null,
    };
  }

  // Create a copy with updated fields
  AppointmentModel copyWith({
    String? id,
    String? specialistId,
    DateTime? appointmentDate,
    String? timeSlot,
    String? status,
    DateTime? createdAt,
    DateTime? lastModified,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      specialistId: specialistId ?? this.specialistId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ??
          DateTime.now(), // Always update lastModified on any change
    );
  }

  // Check if appointment is upcoming
  bool isUpcoming() {
    final now = DateTime.now();
    return status == "scheduled" && appointmentDate.isAfter(now);
  }

  // Check if appointment can be cancelled (more than 6 hours before)
  bool canCancel() {
    final now = DateTime.now();
    // Allow cancellation if there's at least 6 hours remaining
    final difference = appointmentDate.difference(now).inHours;
    return status == "scheduled" && difference >= 2;
  }

  // Check if appointment can be rescheduled (within 2 hours of booking)
  bool canReschedule() {
    final now = DateTime.now();

    // Must be scheduled appointment
    if (status != "scheduled") return false;

    // Must be within 2 hours of the initial booking
    final creationDifference = now.difference(createdAt).inHours;
    return creationDifference <= 2;
  }

  // Get the appointment duration in minutes
  int getDurationMinutes() {
    if (timeSlot.isEmpty) return 60; // Default to 1 hour

    try {
      // Parse time slot (e.g., "9:00 AM - 10:00 AM")
      final parts = timeSlot.split(' - ');
      if (parts.length != 2) return 60;

      // Parse start and end times
      final startTimeParts = _parseTimeString(parts[0]);
      final endTimeParts = _parseTimeString(parts[1]);

      if (startTimeParts == null || endTimeParts == null) return 60;

      // Convert to total minutes
      final startMinutes = startTimeParts.hour * 60 + startTimeParts.minute;
      int endMinutes = endTimeParts.hour * 60 + endTimeParts.minute;

      // Handle case where end time is on the next day (should be rare)
      if (endMinutes < startMinutes) {
        endMinutes += 24 * 60; // Add a full day
      }

      return endMinutes - startMinutes;
    } catch (e) {
      return 60; // Default to 1 hour on parsing error
    }
  }

  // Helper method to parse time strings like "9:00 AM" or "2:30 PM"
  _TimeComponents? _parseTimeString(String timeString) {
    try {
      final parts = timeString.trim().split(' ');
      if (parts.length != 2) return null;

      final isPM = parts[1].toUpperCase() == 'PM';
      final timeParts = parts[0].split(':');

      if (timeParts.length != 2) return null;

      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Convert to 24-hour format
      if (isPM && hour < 12) {
        hour += 12;
      } else if (!isPM && hour == 12) {
        hour = 0;
      }

      return _TimeComponents(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  // Get a user-friendly representation of remaining reschedule time
  String getRescheduleTimeRemaining() {
    final now = DateTime.now();
    final creationTimePlusTwo = createdAt.add(const Duration(hours: 2));
    final difference = creationTimePlusTwo.difference(now);

    if (difference.isNegative) {
      return "No longer eligible for rescheduling";
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return "$hours hour${hours != 1 ? 's' : ''} $minutes minute${minutes != 1 ? 's' : ''} remaining";
    } else {
      return "$minutes minute${minutes != 1 ? 's' : ''} remaining";
    }
  }
}

// Helper class for time parsing
class _TimeComponents {
  final int hour;
  final int minute;

  _TimeComponents({required this.hour, required this.minute});
}
