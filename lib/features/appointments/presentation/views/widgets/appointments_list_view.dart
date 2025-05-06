// features/appointments/presentation/views/widgets/appointments_list_view.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_card.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointments_empty_view.dart';
import 'package:flutter/material.dart';

class AppointmentsListView extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final bool isUpcoming;
  final bool isCancelled;
  final Function(BuildContext, String)? onCancelPressed;
  final Function(BuildContext, AppointmentModel)? onReschedulePressed;

  const AppointmentsListView({
    super.key,
    required this.appointments,
    required this.isUpcoming,
    this.isCancelled = false,
    this.onCancelPressed,
    this.onReschedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return EmptyAppointmentsView(
        isUpcoming: isUpcoming,
        isCancelled: isCancelled,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return AppointmentCard(
          appointment: appointment,
          isUpcoming: isUpcoming,
          onCancelPressed: isUpcoming && appointment.canCancel()
              ? (appointmentId) => onCancelPressed?.call(context, appointmentId)
              : null,
          onReschedulePressed: isUpcoming && appointment.canReschedule()
              ? (appointment) => onReschedulePressed?.call(context, appointment)
              : null,
        );
      },
    );
  }
}
