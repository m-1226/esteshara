// features/specialists/presentation/widgets/existing_appointment_warning.dart
import 'package:flutter/material.dart';

class ExistingAppointmentWarning extends StatelessWidget {
  final String message;
  final VoidCallback? onViewAppointments;

  const ExistingAppointmentWarning({
    super.key,
    required this.message,
    this.onViewAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Existing Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onViewAppointments,
                icon: const Icon(Icons.calendar_today_outlined),
                label: const Text('View My Appointments'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange.shade800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
