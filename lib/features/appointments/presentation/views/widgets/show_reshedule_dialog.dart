import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/reschedule_dialog_content.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showRescheduleDialog(BuildContext context, AppointmentModel appointment) {
  final AppointmentsRepo appointmentsRepo = getIt<AppointmentsRepo>();

  showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: BlocProvider.value(
        value: GetSpecialistsCubit(
          specialistRepo: getIt<SpecialistRepo>(),
        )..getAllSpecialists(),
        child: RescheduleDialogContent(
          appointment: appointment,
          onReschedule: (newDate, newTimeSlot) async {
            Navigator.pop(dialogContext);

            // Call repository directly
            await appointmentsRepo.rescheduleAppointment(
              appointmentId: appointment.id,
              newAppointmentDate: newDate,
              newTimeSlot: newTimeSlot,
            );
            // No need to reload - stream will update automatically
          },
        ),
      ),
    ),
  );
}
