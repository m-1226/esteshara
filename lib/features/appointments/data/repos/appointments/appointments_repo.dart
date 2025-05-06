// features/appointments/data/repos/appointments/appointments_repo.dart
import 'package:esteshara/core/models/appointment_model.dart';

abstract class AppointmentsRepo {
  /// Gets user appointments as a one-time fetch
  Future<List<AppointmentModel>> getUserAppointments();

  /// Gets a real-time stream of user appointments that updates automatically
  Stream<List<AppointmentModel>> getAppointmentsStream();

  Future<String> bookAppointment({
    required String specialistId,
    required DateTime appointmentDate,
    required String timeSlot,
  });

  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newAppointmentDate,
    required String newTimeSlot,
  });

  Future<void> cancelAppointment(String appointmentId);
}
