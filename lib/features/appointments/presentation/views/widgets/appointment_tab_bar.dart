// features/appointments/presentation/views/widgets/appointment_tabs/appointments_tab_bar.dart
import 'package:esteshara/features/appointments/data/models/appointment_type.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_tab_item.dart';
import 'package:flutter/material.dart';

class AppointmentsTabBar extends StatelessWidget {
  const AppointmentsTabBar({super.key});

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
          AppointmentTabItem(
            icon: Icons.event_available,
            label: 'Upcoming',
            tabType: AppointmentTabType.upcoming,
          ),
          AppointmentTabItem(
            icon: Icons.cancel_outlined,
            label: 'Cancelled',
            tabType: AppointmentTabType.cancelled,
          ),
        ],
      ),
    );
  }
}
