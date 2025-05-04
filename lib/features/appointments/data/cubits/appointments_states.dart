// features/appointments/data/cubits/appointments_state.dart
import 'package:equatable/equatable.dart';
import 'package:esteshara/core/models/appointment_model.dart';

abstract class AppointmentsState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial state when cubit is created
class AppointmentsInitial extends AppointmentsState {}

// Loading state while fetching appointments
class AppointmentsLoading extends AppointmentsState {}

// Success state with loaded appointments
class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentModel> appointments;

  AppointmentsLoaded({required this.appointments});

  // Get upcoming appointments
  List<AppointmentModel> get upcomingAppointments => appointments
      .where(
          (appointment) => appointment.appointmentDate.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

  // Get past appointments
  List<AppointmentModel> get pastAppointments => appointments
      .where(
          (appointment) => !appointment.appointmentDate.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));

  @override
  List<Object> get props => [appointments];
}

// Error state with error message
class AppointmentsError extends AppointmentsState {
  final String message;

  AppointmentsError({required this.message});

  @override
  List<Object> get props => [message];
}
