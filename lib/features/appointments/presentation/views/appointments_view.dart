// features/appointments/presentation/views/appointments_view.dart
import 'package:esteshara/features/appointments/data/cubits/appointments_cubit.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/apppointments_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsView extends StatelessWidget {
  const AppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: const AppointmentsViewBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      foregroundColor: Colors.black87,
      title: const Row(
        children: [
          Icon(Icons.calendar_today),
          SizedBox(width: 10),
          Text(
            'My Appointments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Show notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // Refresh appointments
            context.read<AppointmentsCubit>().loadAppointments();
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey.shade200,
          height: 1.0,
        ),
      ),
    );
  }
}
