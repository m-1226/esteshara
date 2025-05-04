// features/appointments/presentation/views/widgets/appointments_view_body.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/appointments/data/cubits/appointments_cubit.dart';
import 'package:esteshara/features/appointments/data/cubits/appointments_states.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_card.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/reschedule_appointment_dialog.dart';
import 'package:esteshara/features/specialists/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/specialists/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/specialists/data/repos/spcialists/specialist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppointmentsViewBody extends StatefulWidget {
  const AppointmentsViewBody({super.key});

  @override
  State<AppointmentsViewBody> createState() => _AppointmentsViewBodyState();
}

class _AppointmentsViewBodyState extends State<AppointmentsViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load appointments when view is created
    context.read<AppointmentsCubit>().loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar for upcoming and past
        _buildTabBar(),

        // Appointments list with BLoC
        Expanded(
          child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
            builder: (context, state) {
              if (state is AppointmentsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AppointmentsError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is AppointmentsLoaded) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Upcoming appointments
                    _buildAppointmentsList(
                      context,
                      state.upcomingAppointments,
                      isUpcoming: true,
                    ),

                    // Past appointments
                    _buildAppointmentsList(
                      context,
                      state.pastAppointments,
                      isUpcoming: false,
                    ),
                  ],
                );
              }

              // Initial state
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(
      BuildContext context, List<AppointmentModel> appointments,
      {required bool isUpcoming}) {
    if (appointments.isEmpty) {
      return _buildEmptyState(isUpcoming, context);
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
              ? (appointmentId) => _confirmCancellation(context, appointmentId)
              : null,
          onReschedulePressed: isUpcoming && appointment.canReschedule()
              ? (appointment) => _showRescheduleDialog(context, appointment)
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState(bool isUpcoming, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUpcoming ? Icons.event_available : Icons.history,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            isUpcoming ? 'No upcoming appointments' : 'No past appointments',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          if (isUpcoming)
            TextButton(
              onPressed: () {
                context.pushReplacement(AppRouters.kSpecialistsView);
              },
              child: const Text('Book an appointment'),
            ),
        ],
      ),
    );
  }

  void _confirmCancellation(BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
            'Are you sure you want to cancel this appointment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO'),
          ),
          ElevatedButton(
            onPressed: () {
              // Close dialog
              Navigator.pop(context);

              // Cancel appointment
              context
                  .read<AppointmentsCubit>()
                  .cancelAppointment(appointmentId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('YES, CANCEL'),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(
      BuildContext context, AppointmentModel appointment) {
    // Create the cubit first
    final specialistsCubit = GetSpecialistsCubit(
      specialistRepo: getIt<SpecialistRepo>(),
    );

    // Show the dialog with a loading state initially
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlocProvider(
          create: (_) =>
              specialistsCubit..getAllSpecialists(), // Start loading here
          child: BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
            builder: (_, state) {
              if (state is SpecialistsLoading || state is SpecialistsInitial) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is SpecialistsError) {
                return SizedBox(
                  height: 200,
                  child: Center(child: Text('Error: ${state.message}')),
                );
              } else if (state is SpecialistsLoaded) {
                try {
                  final specialist = state.specialists.firstWhere(
                    (s) => s.id == appointment.specialistId,
                  );

                  return RescheduleAppointmentDialog(
                    specialist: specialist,
                    appointment: appointment,
                    onReschedule: (newDate, newTimeSlot) {
                      Navigator.pop(dialogContext);

                      // Process rescheduling
                      context.read<AppointmentsCubit>().rescheduleAppointment(
                            appointmentId: appointment.id,
                            newAppointmentDate: newDate,
                            newTimeSlot: newTimeSlot,
                          );
                    },
                  );
                } catch (e) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child:
                          Text('Specialist not found. Please try again later.'),
                    ),
                  );
                }
              }

              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
}
