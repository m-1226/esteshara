// features/appointments/presentation/widgets/reschedule_appointment_dialog.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/appointment_utils.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/date_selector_item.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/spcialist_info_widget.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/time_slot_widget.dart';
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RescheduleAppointmentDialog extends StatefulWidget {
  final SpecialistModel specialist;
  final AppointmentModel appointment;
  final Function(DateTime date, String timeSlot) onReschedule;
  const RescheduleAppointmentDialog({
    super.key,
    required this.specialist,
    required this.appointment,
    required this.onReschedule,
  });

  @override
  State<RescheduleAppointmentDialog> createState() =>
      _RescheduleAppointmentDialogState();
}

class _RescheduleAppointmentDialogState
    extends State<RescheduleAppointmentDialog> {
  late DateTime _selectedDate;
  String? _selectedTimeSlot;
  List<String> _availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    // Find the next available day
    _selectedDate = AppointmentUtils.findNextAvailableDay(widget.specialist);
    _updateAvailableTimeSlots();
  }

  // Update available time slots based on selected day
  void _updateAvailableTimeSlots() {
    // Generate time slots for selected date
    _availableTimeSlots = AppointmentUtils.generateTimeSlots(
      widget.specialist,
      _selectedDate,
    );

    // Reset selected time slot or set to first available
    _selectedTimeSlot =
        _availableTimeSlots.isNotEmpty ? _availableTimeSlots.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final workingHours =
        AppointmentUtils.getWorkingHoursFromTimeSlots(_availableTimeSlots);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 16),

            // Specialist info
            SpecialistInfoWidget(specialist: widget.specialist),

            const Divider(height: 32),

            // Date selection
            _buildDateSelection(),

            const SizedBox(height: 24),

            // Time selection
            _buildTimeSelection(workingHours),

            const SizedBox(height: 24),

            // Confirm button
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Reschedule Appointment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Date selector
        DateSelector(
          selectedDate: _selectedDate,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
              _updateAvailableTimeSlots();
            });
          },
          isAvailableDay: (date) =>
              AppointmentUtils.isAvailableDay(widget.specialist, date),
          daysToShow: 14,
          startFromDays: 1, // Start from tomorrow
        ),
      ],
    );
  }

  Widget _buildTimeSelection(Map<String, String> workingHours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('EEEE, MMMM d').format(_selectedDate),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Show working hours info
        if (_availableTimeSlots.isNotEmpty && workingHours['start']!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Working hours: ${workingHours['start']} - ${workingHours['end']}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),

        // Time slots
        _availableTimeSlots.isEmpty
            ? _buildNoTimeSlotsMessage()
            : _buildTimeSlots(),
      ],
    );
  }

  Widget _buildNoTimeSlotsMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'No available time slots for selected day',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: _availableTimeSlots.map((time) {
        final isSelected = _selectedTimeSlot == time;

        return TimeSlotWidget(
          timeSlot: time,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedTimeSlot = time;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedTimeSlot != null
            ? () => widget.onReschedule(_selectedDate, _selectedTimeSlot!)
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Confirm Reschedule',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
