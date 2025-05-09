import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/canel_appointment_dialog.dart';
import 'package:flutter/material.dart';

void confirmCancellation(BuildContext context, String appointmentId) {
  final AppointmentsRepo appointmentsRepo = getIt<AppointmentsRepo>();

  showDialog(
    context: context,
    builder: (_) => CancelAppointmentDialog(
      appointmentId: appointmentId,
      onCancel: () async {
        await appointmentsRepo.cancelAppointment(appointmentId);
      },
    ),
  );
}
