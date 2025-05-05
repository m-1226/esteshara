// features/appointments/presentation/widgets/appointment_card.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_utils.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/spcialist_info_widget.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo.dart';
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
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(appointment.appointmentDate, now);
    final isTomorrow = DateUtils.isSameDay(
        appointment.appointmentDate, now.add(const Duration(days: 1)));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Column(
          children: [
            // Date header with status
            _buildDateHeader(context, isToday, isTomorrow),

            // Appointment details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time info
                  _buildTimeInfo(context),

                  const SizedBox(height: 16),

                  // Divider
                  Divider(color: Colors.grey.shade200),

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
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Cannot modify (less than 6 hours notice)',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, bool isToday, bool isTomorrow) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    String dateText;

    if (isToday) {
      dateText = 'Today';
    } else if (isTomorrow) {
      dateText = 'Tomorrow';
    } else {
      dateText = dateFormat.format(appointment.appointmentDate);
    }

    final statusColor = AppointmentUtils.getStatusColor(appointment.status);
    final statusText = AppointmentUtils.getStatusText(appointment.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: appointment.status == 'scheduled'
            ? isUpcoming
                ? Colors.blue.shade50
                : Colors.grey.shade50
            : statusColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isToday
                    ? Icons.today
                    : isTomorrow
                        ? Icons.event
                        : Icons.calendar_month,
                size: 16,
                color: isUpcoming ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                dateText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      isUpcoming ? Colors.blue.shade700 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: statusColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  appointment.status == 'scheduled'
                      ? Icons.check_circle_outline
                      : appointment.status == 'cancelled'
                          ? Icons.cancel_outlined
                          : Icons.task_alt,
                  size: 14,
                  color: statusColor,
                ),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    // Extract time from the time slot (e.g., "9:00 AM - 10:00 AM")
    final timeSlotParts = appointment.timeSlot.split(' - ');
    final startTime = timeSlotParts.isNotEmpty ? timeSlotParts[0] : '';
    final endTime = timeSlotParts.length > 1 ? timeSlotParts[1] : '';

    // Calculate remaining time for upcoming appointments
    final now = DateTime.now();
    final appointmentDateTime = appointment.appointmentDate;
    final difference = appointmentDateTime.difference(now);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    String remainingText = '';
    if (difference.isNegative) {
      // Appointment has passed
      if (appointment.status == 'scheduled') {
        remainingText = 'In progress';
      }
    } else if (hours < 24) {
      // Less than a day
      if (hours > 0) {
        remainingText = 'Starts in $hours hour${hours != 1 ? 's' : ''}';
        if (minutes > 0) {
          remainingText += ' $minutes min${minutes != 1 ? 's' : ''}';
        }
      } else {
        remainingText = 'Starts in $minutes minute${minutes != 1 ? 's' : ''}';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_filled,
              color: Theme.of(context).colorScheme.onSurface,
              size: 28,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  startTime,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'to $endTime',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (remainingText.isNotEmpty && isUpcoming)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hours < 6 ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      hours < 6 ? Icons.timer : Icons.timer_outlined,
                      size: 12,
                      color: hours < 6 ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      remainingText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: hours < 6 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
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
              return _buildSpecialistRow(context, specialist);
            } catch (e) {
              // Specialist not found
              return _buildSpecialistNotFoundRow();
            }
          }

          // Loading or error state
          return const SpecialistLoading();
        },
      ),
    );
  }

  Widget _buildSpecialistRow(BuildContext context, SpecialistModel specialist) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpecialistInfoWidget(
          specialist: specialist,
          avatarRadius: 25,
          nameSize: 16,
          specializationSize: 14,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${specialist.price.toInt()} EGP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
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
          radius: 25,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Specialist unavailable',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'ID: ${appointment.specialistId}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Reschedule button
          if (isUpcoming &&
              appointment.canReschedule() &&
              onReschedulePressed != null)
            OutlinedButton.icon(
              onPressed: () => onReschedulePressed!(appointment),
              icon: const Icon(Icons.edit_calendar, size: 16),
              label: const Text('Reschedule'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),

          if (isUpcoming &&
              appointment.canReschedule() &&
              appointment.canCancel())
            const SizedBox(width: 12),

          // Cancel button
          if (isUpcoming && appointment.canCancel() && onCancelPressed != null)
            OutlinedButton.icon(
              onPressed: () => onCancelPressed!(appointment.id),
              icon: const Icon(Icons.cancel_outlined, size: 16),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
        ],
      ),
    );
  }
}
