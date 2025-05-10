import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/profile/presentation/views/widgets/profile_stats_card.dart';
import 'package:flutter/material.dart';

class ProfileStatsSection extends StatelessWidget {
  final dynamic userModel;

  const ProfileStatsSection({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    // Get appointments repo from service locator
    final appointmentsRepo = getIt<AppointmentsRepo>();

    // Use stream for real-time updates
    return StreamBuilder(
      stream: appointmentsRepo.getAppointmentsStream(),
      builder: (context, snapshot) {
        final stats = _calculateStats(snapshot.data);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: ProfileStatsCard(
                  icon: Icons.check_circle_outline,
                  title: 'Completed',
                  value: stats.completedAppointments.toString(),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileStatsCard(
                  icon: Icons.calendar_today,
                  title: 'Upcoming',
                  value: stats.upcomingAppointments.toString(),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileStatsCard(
                  icon: Icons.savings_outlined,
                  title: 'Saved',
                  value: '${stats.savedMoney.toInt()} EGP',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _ProfileStats _calculateStats(dynamic appointmentsData) {
    int completedAppointments = 0;
    int upcomingAppointments = 0;
    double savedMoney = 0.0;

    // Use appointments from stream if available, otherwise fall back to userModel
    final appointments = appointmentsData ?? userModel.appointments;

    if (appointments != null && appointments is List) {
      final now = DateTime.now();
      for (var appointment in appointments) {
        if (appointment.status == 'completed') {
          completedAppointments++;
        } else if (appointment.status == 'scheduled') {
          try {
            final appointmentDate = appointment.appointmentDate;
            if (appointmentDate != null && appointmentDate.isAfter(now)) {
              upcomingAppointments++;
            }
          } catch (e) {
            // Skip if date parsing fails
          }
        }
      }
      // This is just a placeholder calculation for saved money
      savedMoney = completedAppointments * 50.0;
    }

    return _ProfileStats(
      completedAppointments: completedAppointments,
      upcomingAppointments: upcomingAppointments,
      savedMoney: savedMoney,
    );
  }
}

class _ProfileStats {
  final int completedAppointments;
  final int upcomingAppointments;
  final double savedMoney;

  _ProfileStats({
    required this.completedAppointments,
    required this.upcomingAppointments,
    required this.savedMoney,
  });
}
