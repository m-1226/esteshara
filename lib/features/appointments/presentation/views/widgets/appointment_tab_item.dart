// features/appointments/presentation/views/widgets/appointment_tabs/tab_item.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/models/appointment_type.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:flutter/material.dart';

class AppointmentTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppointmentTabType tabType;

  const AppointmentTabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.tabType,
  });

  @override
  Widget build(BuildContext context) {
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
          TabCounter(tabType: tabType),
        ],
      ),
    );
  }
}

class TabCounter extends StatelessWidget {
  final AppointmentTabType tabType;
  // Get repository directly
  final AppointmentsRepo _appointmentsRepo = getIt<AppointmentsRepo>();

  TabCounter({
    super.key,
    required this.tabType,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppointmentModel>>(
      stream: _appointmentsRepo.getAppointmentsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final appointments = snapshot.data!;
          int count = 0;

          // Get count based on tab type
          switch (tabType) {
            case AppointmentTabType.upcoming:
              count = appointments
                  .where((a) =>
                      a.status != 'cancelled' &&
                      a.appointmentDate.isAfter(DateTime.now()))
                  .length;
              break;
            case AppointmentTabType.past:
              count = appointments
                  .where((a) =>
                      (a.status == 'scheduled' || a.status == 'completed') &&
                      a.appointmentDate.isBefore(DateTime.now()))
                  .length;
              break;
            case AppointmentTabType.cancelled:
              count = appointments.where((a) => a.status == 'cancelled').length;
              break;
          }

          if (count > 0) {
            return Container(
              margin: const EdgeInsets.only(left: 2),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: tabType == AppointmentTabType.cancelled
                    ? Colors.red.shade100
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: tabType == AppointmentTabType.cancelled
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
