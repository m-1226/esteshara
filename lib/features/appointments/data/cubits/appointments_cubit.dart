// features/appointments/data/cubits/appointments_cubit.dart
import 'dart:async';

import 'package:esteshara/features/appointments/data/cubits/appointments_states.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentsRepo _appointmentsRepo;

  // Add a StreamController to broadcast state changes
  final _appointmentsController =
      StreamController<AppointmentsState>.broadcast();

  // Expose the stream for listeners
  Stream<AppointmentsState> get appointmentsStream =>
      _appointmentsController.stream;

  AppointmentsCubit({
    required AppointmentsRepo appointmentsRepo,
  })  : _appointmentsRepo = appointmentsRepo,
        super(AppointmentsInitial()) {
    // Forward state changes to the stream
    stream.listen((state) {
      _appointmentsController.add(state);
    });
  }

  @override
  Future<void> close() {
    _appointmentsController.close();
    return super.close();
  }

  // Load appointments for current user
  Future<void> loadAppointments() async {
    emit(AppointmentsLoading());
    try {
      final appointments = await _appointmentsRepo.getUserAppointments();
      final newState = AppointmentsLoaded(appointments: appointments);
      emit(newState);
    } catch (e) {
      final errorState = AppointmentsError(message: e.toString());
      emit(errorState);
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

  // Reschedule an appointment with validation
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newAppointmentDate,
    required String newTimeSlot,
  }) async {
    final currentState = state;
    try {
      // If we have appointments loaded, check eligibility first
      if (currentState is AppointmentsLoaded) {
        final appointment = currentState.appointments.firstWhere(
          (a) => a.id == appointmentId,
          orElse: () => throw Exception('Appointment not found'),
        );

        // Check if appointment can be rescheduled
        if (!appointment.canReschedule()) {
          throw Exception('Appointment is no longer eligible for rescheduling. '
              'Rescheduling must be done within 2 hours of booking.');
        }

        // Update the UI optimistically
        final updatedAppointments = currentState.appointments.map((a) {
          if (a.id == appointmentId) {
            return a.copyWith(
              appointmentDate: newAppointmentDate,
              timeSlot: newTimeSlot,
              lastModified: DateTime.now(),
            );
          }
          return a;
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
        final appointment = currentState.appointments.firstWhere(
          (a) => a.id == appointmentId,
          orElse: () => throw Exception('Appointment not found'),
        );

        // Check if appointment can be canceled
        if (!appointment.canCancel()) {
          throw Exception('Appointment cannot be cancelled. '
              'Cancellation must be done at least 6 hours before the appointment.');
        }

        final updatedAppointments = currentState.appointments.map((a) {
          if (a.id == appointmentId) {
            return a.copyWith(
              status: 'cancelled',
              lastModified: DateTime.now(),
            );
          }
          return a;
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
