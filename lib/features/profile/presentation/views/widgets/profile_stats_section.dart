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
    final stats = _calculateStats();

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
  }

  _ProfileStats _calculateStats() {
    int completedAppointments = 0;
    int upcomingAppointments = 0;
    double savedMoney = 0.0;

    // Check if appointments field exists and is properly formatted
    if (userModel.appointments != null && userModel.appointments is List) {
      final now = DateTime.now();

      for (var appointment in userModel.appointments) {
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
