import 'package:esteshara/features/appointments/presentation/views/widgets/apppointments_view_body.dart';
// features/appointments/presentation/views/appointments_view.dart
import 'package:flutter/material.dart';

class AppointmentsView extends StatelessWidget {
  const AppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        elevation: 0,
      ),
      body: const AppointmentsViewBody(),
    );
  }
}
