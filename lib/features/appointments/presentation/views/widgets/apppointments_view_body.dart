// features/appointments/presentation/views/widgets/appointments_view_body.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/appointments/data/cubits/appointments_cubit.dart';
import 'package:esteshara/features/appointments/data/cubits/appointments_states.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_card.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/reschedule_appointment_dialog.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentsViewBody extends StatefulWidget {
  const AppointmentsViewBody({super.key});

  @override
  State<AppointmentsViewBody> createState() => _AppointmentsViewBodyState();
}

class _AppointmentsViewBodyState extends State<AppointmentsViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load appointments when view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentsCubit>().loadAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshAppointments() async {
    await context.read<AppointmentsCubit>().loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar for upcoming and past
        _buildTabBar(),

        // Appointments list with BLoC
        Expanded(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshAppointments,
            color: Theme.of(context).primaryColor,
            child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
              builder: (context, state) {
                if (state is AppointmentsLoading) {
                  return _buildLoadingState();
                } else if (state is AppointmentsError) {
                  return _buildErrorState(state.message);
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
                return _buildLoadingState();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          color: Theme.of(context).primaryColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        padding: const EdgeInsets.all(4),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event_available, size: 16),
                const SizedBox(width: 8),
                const Text('Upcoming'),
                BlocBuilder<AppointmentsCubit, AppointmentsState>(
                  builder: (context, state) {
                    if (state is AppointmentsLoaded &&
                        state.upcomingAppointments.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${state.upcomingAppointments.length}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history, size: 16),
                const SizedBox(width: 8),
                const Text('Past'),
                BlocBuilder<AppointmentsCubit, AppointmentsState>(
                  builder: (context, state) {
                    if (state is AppointmentsLoaded &&
                        state.pastAppointments.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${state.pastAppointments.length}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, __) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 180,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 80,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshAppointments,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isUpcoming ? Icons.event_available : Icons.history,
                  size: 64,
                  color: isUpcoming
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isUpcoming
                    ? 'No Upcoming Appointments'
                    : 'No Past Appointments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isUpcoming
                    ? 'You don\'t have any upcoming appointments scheduled.'
                    : 'You haven\'t had any consultations yet.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (isUpcoming)
                ElevatedButton.icon(
                  onPressed: () {
                    context.push(AppRouters.kHomeView);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Book an Appointment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCancellation(BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red.shade400,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cancel Appointment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to cancel this appointment? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: const Text('NO, KEEP IT'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<AppointmentsCubit>()
                            .cancelAppointment(appointmentId);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('YES, CANCEL'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 48,
                        width: 48,
                        child: CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Loading Specialist Data...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is SpecialistsError) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade400,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
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
                  return Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_off,
                          color: Colors.red.shade400,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Specialist not found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The specialist for this appointment could not be found. Please try again later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              }

              return Container(
                padding: const EdgeInsets.all(24),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
