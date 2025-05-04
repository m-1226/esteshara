// features/appointments/presentation/widgets/appointment_card_widget.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_utils.dart';
import 'package:esteshara/features/specialists/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/specialists/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
import 'package:esteshara/features/specialists/data/repos/spcialists/specialist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final bool isUpcoming;
  final Function(String appointmentId)? onCancelPressed;
  final Function(AppointmentModel appointment)? onReschedulePressed;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.isUpcoming,
    this.onCancelPressed,
    this.onReschedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status chip
            _buildStatusChip(),
            const SizedBox(height: 12),

            // Date and time
            _buildDateTimeInfo(),

            const SizedBox(height: 16),

            // Specialist info
            _buildSpecialistInfo(),

            // Action buttons
            if (isUpcoming &&
                (appointment.canCancel() || appointment.canReschedule()))
              _buildActionButtons(context),

            // Cannot cancel/reschedule message
            if (isUpcoming && !appointment.canCancel())
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Cannot modify (less than 6 hours notice)',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    final statusColor = AppointmentUtils.getStatusColor(appointment.status);
    final statusText = AppointmentUtils.getStatusText(appointment.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateTimeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.event, size: 20),
            const SizedBox(width: 8),
            Text(
              DateFormat('EEEE, MMMM d, yyyy')
                  .format(appointment.appointmentDate),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time, size: 20),
            const SizedBox(width: 8),
            Text(appointment.timeSlot),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecialistInfo() {
    return BlocProvider(
      create: (context) => GetSpecialistsCubit(
        specialistRepo: getIt<SpecialistRepo>(),
      )..getAllSpecialists(),
      child: BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
        builder: (context, state) {
          if (state is SpecialistsLoaded) {
            try {
              final specialist = state.specialists.firstWhere(
                (specialist) => specialist.id == appointment.specialistId,
              );
              return _buildSpecialistRow(specialist);
            } catch (e) {
              // Specialist not found
              return _buildSpecialistNotFoundRow();
            }
          }

          // Loading or error state
          return _buildSpecialistLoadingRow();
        },
      ),
    );
  }

  Widget _buildSpecialistRow(SpecialistModel specialist) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: specialist.photoUrl.isNotEmpty
              ? NetworkImage(specialist.photoUrl)
              : null,
          child: specialist.photoUrl.isEmpty
              ? Text(specialist.name.isNotEmpty
                  ? specialist.name[0].toUpperCase()
                  : 'U')
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                specialist.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                specialist.specialization,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialistNotFoundRow() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          child: Icon(Icons.person),
        ),
        const SizedBox(width: 8),
        Text(
          'Specialist ID: ${appointment.specialistId}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSpecialistLoadingRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            Icons.person,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 10,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Reschedule button
          if (isUpcoming &&
              appointment.canReschedule() &&
              onReschedulePressed != null)
            TextButton(
              onPressed: () => onReschedulePressed!(appointment),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Reschedule'),
            ),

          // Cancel button
          if (isUpcoming && appointment.canCancel() && onCancelPressed != null)
            TextButton(
              onPressed: () => onCancelPressed!(appointment.id),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Cancel'),
            ),
        ],
      ),
    );
  }
}
