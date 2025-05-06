// features/appointments/presentation/views/appointments_view_body.dart
import 'dart:developer';

import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_error_view.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_loading_view.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_tab_bar.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointments_list_view.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/canel_appointment_dialog.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/reschedule_dialog_content.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsViewBody extends StatefulWidget {
  const AppointmentsViewBody({super.key});

  @override
  State<AppointmentsViewBody> createState() => _AppointmentsViewBodyState();
}

class _AppointmentsViewBodyState extends State<AppointmentsViewBody> {
  // Get repository directly
  final AppointmentsRepo _appointmentsRepo = getIt<AppointmentsRepo>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // This just triggers a UI refresh - the stream will still provide the latest data
  Future<void> _refreshAppointments() async {
    // Since we're using a direct stream from Firestore, this doesn't need to do much
    setState(() {
      // Force a rebuild
    });

    return Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar - uses DefaultTabController from parent
        AppointmentsTabBar(),

        // Appointments list
        Expanded(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshAppointments,
            color: Theme.of(context).primaryColor,
            child: StreamBuilder<List<AppointmentModel>>(
              // Use repo stream directly for real-time updates
              stream: _appointmentsRepo.getAppointmentsStream(),
              builder: (context, snapshot) {
                // Handle loading state
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const AppointmentsLoadingView();
                }

                // Handle error state
                else if (snapshot.hasError) {
                  log('Error loading appointments: ${snapshot.error}');
                  return AppointmentsErrorView(
                    message: snapshot.error.toString(),
                    onRetry: _refreshAppointments,
                  );
                }

                // Handle data state
                else if (snapshot.hasData) {
                  final appointments = snapshot.data!;

                  // Filter appointments for each tab
                  final upcomingAppointments = appointments
                      .where((a) =>
                          a.status != 'cancelled' &&
                          a.appointmentDate.isAfter(DateTime.now()))
                      .toList();

                  final cancelledAppointments = appointments
                      .where((a) => a.status == 'cancelled')
                      .toList();

                  // Log for debugging
                  log('Loaded ${appointments.length} appointments (${upcomingAppointments.length} upcoming, ${cancelledAppointments.length} cancelled)');

                  return TabBarView(
                    children: [
                      // Upcoming appointments
                      AppointmentsListView(
                        appointments: upcomingAppointments,
                        isUpcoming: true,
                        onCancelPressed: _confirmCancellation,
                        onReschedulePressed: _showRescheduleDialog,
                      ),

                      // Cancelled appointments
                      AppointmentsListView(
                        appointments: cancelledAppointments,
                        isUpcoming: false,
                        isCancelled: true,
                      ),
                    ],
                  );
                }

                // Default loading view
                return const AppointmentsLoadingView();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _confirmCancellation(BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (_) => CancelAppointmentDialog(
        appointmentId: appointmentId,
        onCancel: () async {
          // Call repository directly
          await _appointmentsRepo.cancelAppointment(appointmentId);
          // No need to reload - stream will update automatically
        },
      ),
    );
  }

  void _showRescheduleDialog(
      BuildContext context, AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlocProvider(
          create: (_) => GetSpecialistsCubit(
            specialistRepo: getIt<SpecialistRepo>(),
          )..getAllSpecialists(),
          child: RescheduleDialogContent(
            appointment: appointment,
            onReschedule: (newDate, newTimeSlot) async {
              Navigator.pop(dialogContext);

              // Call repository directly
              await _appointmentsRepo.rescheduleAppointment(
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
}
