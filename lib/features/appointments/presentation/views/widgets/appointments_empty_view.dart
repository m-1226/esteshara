// features/appointments/presentation/views/widgets/empty_appointments_view.dart
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              EmptyStateIcon(
                icon: icon,
                iconColor: iconColor,
                isUpcoming: isUpcoming,
                isCancelled: isCancelled,
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
              EmptyStateMessage(message: message),
              const SizedBox(height: 24),
              if (isUpcoming) BookAppointmentButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyStateIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool isUpcoming;
  final bool isCancelled;

  const EmptyStateIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.isUpcoming,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class EmptyStateMessage extends StatelessWidget {
  final String message;

  const EmptyStateMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class BookAppointmentButton extends StatelessWidget {
  const BookAppointmentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.push(AppRouters.kHomeView);
      },
      icon: const Icon(Icons.add),
      label: const Text('Book an Appointment'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
