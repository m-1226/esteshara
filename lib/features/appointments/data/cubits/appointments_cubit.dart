// features/appointments/data/cubits/appointments_cubit.dart
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This cubit is maintained only for backward compatibility
// New code should use the repository stream directly
class AppointmentsCubit extends Cubit<void> {
  final AppointmentsRepo _appointmentsRepo;

  AppointmentsCubit({
    required AppointmentsRepo appointmentsRepo,
  })  : _appointmentsRepo = appointmentsRepo,
        super(null);

  // Book a new appointment
  Future<void> bookAppointment({
    required String specialistId,
    required DateTime appointmentDate,
    required String timeSlot,
  }) async {
    await _appointmentsRepo.bookAppointment(
      specialistId: specialistId,
      appointmentDate: appointmentDate,
      timeSlot: timeSlot,
    );
  }

  // Reschedule an appointment
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newAppointmentDate,
    required String newTimeSlot,
  }) async {
    await _appointmentsRepo.rescheduleAppointment(
      appointmentId: appointmentId,
      newAppointmentDate: newAppointmentDate,
      newTimeSlot: newTimeSlot,
    );
  }

  // Cancel an appointment
  Future<void> cancelAppointment(String appointmentId) async {
    await _appointmentsRepo.cancelAppointment(appointmentId);
  }
}
