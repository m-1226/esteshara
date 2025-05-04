// features/appointments/data/repos/appointments_repo.dart
import 'package:esteshara/core/models/appointment_model.dart';

abstract class AppointmentsRepo {
  // Get all appointments for the current user
  Future<List<AppointmentModel>> getUserAppointments();

  // Book a new appointment
  Future<String> bookAppointment({
    required String specialistId,
    required DateTime appointmentDate,
    required String timeSlot,
  });

// Add to AppointmentsRepo
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newAppointmentDate,
    required String newTimeSlot,
  });
  // Cancel an appointment
  Future<void> cancelAppointment(String appointmentId);
}
