// features/appointments/presentation/views/appointments_view_body.dart
import 'dart:developer';

import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_error_view.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_loading_view.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_tab_bar.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointments_list_view.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/cancel_confirmation_dailog.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/show_reshedule_dialog.dart';
import 'package:flutter/material.dart';

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
                        onCancelPressed: confirmCancellation,
                        onReschedulePressed: showRescheduleDialog,
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
}
