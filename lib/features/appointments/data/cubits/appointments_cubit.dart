// features/appointments/data/cubits/appointments_cubit.dart

import 'package:esteshara/features/appointments/data/cubits/appointments_states.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentsRepo _appointmentsRepo;

  AppointmentsCubit({
    required AppointmentsRepo appointmentsRepo,
  })  : _appointmentsRepo = appointmentsRepo,
        super(AppointmentsInitial());

  // Load appointments for current user
  Future<void> loadAppointments() async {
    emit(AppointmentsLoading());

    try {
      final appointments = await _appointmentsRepo.getUserAppointments();
      emit(AppointmentsLoaded(appointments: appointments));
    } catch (e) {
      emit(AppointmentsError(message: e.toString()));
    }
  }

  // Book a new appointment
  Future<void> bookAppointment({
    required String specialistId,
    required DateTime appointmentDate,
    required String timeSlot,
  }) async {
    final currentState = state;

    try {
      // Book the appointment
      await _appointmentsRepo.bookAppointment(
        specialistId: specialistId,
        appointmentDate: appointmentDate,
        timeSlot: timeSlot,
      );

      // Reload appointments to get updated list
      await loadAppointments();
    } catch (e) {
      emit(AppointmentsError(message: e.toString()));

      // Restore previous state if there was an error
      if (currentState is AppointmentsLoaded) {
        emit(currentState);
      }
    }
  }

  // Add to AppointmentsCubit
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newAppointmentDate,
    required String newTimeSlot,
  }) async {
    final currentState = state;
    try {
      // If we have appointments loaded, update the UI optimistically
      if (currentState is AppointmentsLoaded) {
        final updatedAppointments =
            currentState.appointments.map((appointment) {
          if (appointment.id == appointmentId) {
            return appointment.copyWith(
              appointmentDate: newAppointmentDate,
              timeSlot: newTimeSlot,
            );
          }
          return appointment;
        }).toList();
        emit(AppointmentsLoaded(appointments: updatedAppointments));
      }

      // Actually reschedule the appointment in the backend
      await _appointmentsRepo.rescheduleAppointment(
        appointmentId: appointmentId,
        newAppointmentDate: newAppointmentDate,
        newTimeSlot: newTimeSlot,
      );

      // Reload appointments to get confirmed updated list
      await loadAppointments();
    } catch (e) {
      emit(AppointmentsError(message: e.toString()));
      // Restore previous state if there was an error
      if (currentState is AppointmentsLoaded) {
        emit(currentState);
      }
    }
  }

  // Cancel an appointment
  Future<void> cancelAppointment(String appointmentId) async {
    final currentState = state;

    try {
      // If we have appointments loaded, update the UI optimistically
      if (currentState is AppointmentsLoaded) {
        final updatedAppointments =
            currentState.appointments.map((appointment) {
          if (appointment.id == appointmentId) {
            return appointment.copyWith(status: 'cancelled');
          }
          return appointment;
        }).toList();

        emit(AppointmentsLoaded(appointments: updatedAppointments));
      }

      // Actually cancel the appointment in the backend
      await _appointmentsRepo.cancelAppointment(appointmentId);

      // Reload appointments to get confirmed updated list
      await loadAppointments();
    } catch (e) {
      emit(AppointmentsError(message: e.toString()));

      // Restore previous state if there was an error
      if (currentState is AppointmentsLoaded) {
        emit(currentState);
      }
    }
  }
}
