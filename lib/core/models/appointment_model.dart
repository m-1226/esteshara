// core/models/appointment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String specialistId;
  final DateTime appointmentDate;
  final String timeSlot;
  final String status; // "scheduled", "completed", "cancelled"

  AppointmentModel({
    required this.id,
    required this.specialistId,
    required this.appointmentDate,
    required this.timeSlot,
    this.status = "scheduled",
  });

  // Create from Map (for Firestore)
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      specialistId: map['specialistId'] ?? '',
      appointmentDate: (map['appointmentDate'] as Timestamp).toDate(),
      timeSlot: map['timeSlot'] ?? '',
      status: map['status'] ?? 'scheduled',
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
    };
  }

  // Create a copy with updated fields
  AppointmentModel copyWith({
    String? id,
    String? specialistId,
    DateTime? appointmentDate,
    String? timeSlot,
    String? status,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      specialistId: specialistId ?? this.specialistId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
    );
  }

  // Check if appointment is upcoming
  bool isUpcoming() {
    final now = DateTime.now();
    return status == "scheduled" && appointmentDate.isAfter(now);
  }

  // Check if appointment can be cancelled (more than 24h before)
  // Update the canCancel method in AppointmentModel
  // Update the canCancel method in AppointmentModel
  bool canCancel() {
    final now = DateTime.now();
    // Allow cancellation if there's at least 6 hours remaining
    final difference = appointmentDate.difference(now).inHours;
    return status == "scheduled" && difference >= 6;
  }

// Update the canReschedule method in AppointmentModel
  bool canReschedule() {
    // Use same logic as cancellation - more than 6 hours before appointment
    return canCancel();
  }
}
