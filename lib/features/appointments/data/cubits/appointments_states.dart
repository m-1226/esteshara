// features/appointments/data/cubits/appointments_states.dart
import 'package:equatable/equatable.dart';
import 'package:esteshara/core/models/appointment_model.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentModel> appointments;

  // Get upcoming appointments (scheduled appointments in the future)
  List<AppointmentModel> get upcomingAppointments => appointments
      .where((appointment) =>
          appointment.status == 'scheduled' &&
          appointment.appointmentDate.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

  // Get past appointments (completed appointments or appointments in the past)
  List<AppointmentModel> get pastAppointments => appointments
      .where((appointment) =>
          (appointment.status == 'scheduled' ||
              appointment.status == 'completed') &&
          appointment.appointmentDate.isBefore(DateTime.now()))
      .toList()
    ..sort((a, b) =>
        b.appointmentDate.compareTo(a.appointmentDate)); // Sort descending

  // Get cancelled appointments
  List<AppointmentModel> get cancelledAppointments => appointments
      .where((appointment) => appointment.status == 'cancelled')
      .toList()
    ..sort((a, b) =>
        b.appointmentDate.compareTo(a.appointmentDate)); // Sort descending

  const AppointmentsLoaded({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}
