import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/appointments/data/cubits/appointments_cubit.dart';
import 'package:esteshara/features/appointments/data/cubits/appointments_states.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_card.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/canel_appointment_dialog.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/reschedule_dialog_content.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

// Simple tab enum for clear type safety
enum AppointmentTabType {
  upcoming,
  past,
  cancelled,
}

class AppointmentsViewBody extends StatefulWidget {
  const AppointmentsViewBody({super.key});

  @override
  State<AppointmentsViewBody> createState() => _AppointmentsViewBodyState();
}

class _AppointmentsViewBodyState extends State<AppointmentsViewBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load appointments when view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentsCubit>().loadAppointments();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the DefaultTabController and sync with our controller
    final defaultController = DefaultTabController.of(context);
    _tabController.index = defaultController.index;
    _tabController.addListener(() {
      if (mounted && defaultController.index != _tabController.index) {
        defaultController.animateTo(_tabController.index);
      }
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
        // Tab bar
        AppointmentsTabBar(tabController: _tabController),

        // Appointments list
        Expanded(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshAppointments,
            color: Theme.of(context).primaryColor,
            child: StreamBuilder<AppointmentsState>(
              stream: context.read<AppointmentsCubit>().appointmentsStream,
              initialData: context.read<AppointmentsCubit>().state,
              builder: (context, snapshot) {
                final state = snapshot.data;

                if (state is AppointmentsLoading) {
                  return const AppointmentsLoadingView();
                } else if (state is AppointmentsError) {
                  return AppointmentsErrorView(
                    message: state.message,
                    onRetry: _refreshAppointments,
                  );
                } else if (state is AppointmentsLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // Upcoming appointments
                      AppointmentsListView(
                        appointments: state.upcomingAppointments,
                        isUpcoming: true,
                        onCancelPressed: _confirmCancellation,
                        onReschedulePressed: _showRescheduleDialog,
                      ),

                      // Past appointments
                      AppointmentsListView(
                        appointments: state.pastAppointments,
                        isUpcoming: false,
                      ),

                      // Cancelled appointments
                      AppointmentsListView(
                        appointments: state.cancelledAppointments,
                        isUpcoming: false,
                        isCancelled: true,
                      ),
                    ],
                  );
                }

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
        onCancel: () =>
            context.read<AppointmentsCubit>().cancelAppointment(appointmentId),
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
            onReschedule: (newDate, newTimeSlot) {
              Navigator.pop(dialogContext);
              context.read<AppointmentsCubit>().rescheduleAppointment(
                    appointmentId: appointment.id,
                    newAppointmentDate: newDate,
                    newTimeSlot: newTimeSlot,
                  );
            },
          ),
        ),
      ),
    );
  }
}

// Clean AppointmentsTabBar with proper spacing
class AppointmentsTabBar extends StatelessWidget {
  final TabController tabController;

  const AppointmentsTabBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        labelPadding: const EdgeInsets.symmetric(horizontal: 0),
        tabs: [
          _buildTab(context, Icons.event_available, 'Upcoming',
              AppointmentTabType.upcoming),
          _buildTab(context, Icons.history, 'Past', AppointmentTabType.past),
          _buildTab(context, Icons.cancel_outlined, 'Cancelled',
              AppointmentTabType.cancelled),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, IconData icon, String label,
      AppointmentTabType type) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          _buildCounter(context, type),
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context, AppointmentTabType type) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        if (state is AppointmentsLoaded) {
          int count = 0;

          // Get count based on tab type
          switch (type) {
            case AppointmentTabType.upcoming:
              count = state.upcomingAppointments.length;
              break;
            case AppointmentTabType.past:
              count = state.pastAppointments.length;
              break;
            case AppointmentTabType.cancelled:
              count = state.cancelledAppointments.length;
              break;
          }

          if (count > 0) {
            return Container(
              margin: const EdgeInsets.only(left: 2),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: type == AppointmentTabType.cancelled
                    ? Colors.red.shade100
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: type == AppointmentTabType.cancelled
                      ? Colors.red.shade700
                      : Theme.of(context).primaryColor,
                ),
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class AppointmentsLoadingView extends StatelessWidget {
  const AppointmentsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, __) => const ShimmerAppointmentCard(),
    );
  }
}

class ShimmerAppointmentCard extends StatelessWidget {
  const ShimmerAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class AppointmentsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppointmentsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
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
}

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

class EmptyAppointmentsView extends StatelessWidget {
  final bool isUpcoming;
  final bool isCancelled;

  const EmptyAppointmentsView({
    super.key,
    required this.isUpcoming,
    this.isCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    // Different messages and icons based on tab type
    final String title;
    final String message;
    final IconData icon;
    final Color iconColor;

    if (isCancelled) {
      title = 'No Cancelled Appointments';
      message = 'You don\'t have any cancelled appointments.';
      icon = Icons.cancel_outlined;
      iconColor = Colors.red.shade400;
    } else if (isUpcoming) {
      title = 'No Upcoming Appointments';
      message = 'You don\'t have any upcoming appointments scheduled.';
      icon = Icons.event_available;
      iconColor = Theme.of(context).primaryColor;
    } else {
      title = 'No Past Appointments';
      message = 'You haven\'t had any consultations yet.';
      icon = Icons.history;
      iconColor = Colors.grey.shade400;
    }

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
                  color: isCancelled
                      ? Colors.red.shade50
                      : isUpcoming
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
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
}
