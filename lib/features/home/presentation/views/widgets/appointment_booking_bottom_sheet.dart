// features/specialists/presentation/widgets/appointment_booking_bottom_sheet.dart
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/time_slot_widget.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentBookingBottomSheet extends StatefulWidget {
  final SpecialistModel specialist;

  const AppointmentBookingBottomSheet({
    super.key,
    required this.specialist,
  });

  @override
  State<AppointmentBookingBottomSheet> createState() =>
      _AppointmentBookingBottomSheetState();
}

class _AppointmentBookingBottomSheetState
    extends State<AppointmentBookingBottomSheet> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<String> _availableTimeSlots = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Find the next available day
    _findNextAvailableDay();
  }

  void _findNextAvailableDay() {
    // Get the day names of available times
    final availableDayNames =
        widget.specialist.availableTimes.map((time) => time.day).toList();

    // Start from today
    DateTime checkDate = DateTime.now();

    // Check up to 14 days ahead
    for (int i = 0; i < 14; i++) {
      // Get the day name (e.g., "Monday")
      final dayName = DateFormat('EEEE').format(checkDate);

      // If this day name is in available days, select it
      if (availableDayNames.contains(dayName)) {
        setState(() {
          _selectedDate = checkDate;
          // Update time slots for this day
          _updateAvailableTimeSlots(dayName);
        });
        return;
      }

      // Try the next day
      checkDate = checkDate.add(const Duration(days: 1));
    }

    // If no available day found, keep today's date
  }

  // Update available time slots based on selected day
  void _updateAvailableTimeSlots(String dayName) {
    // Find the matching availability time for the day
    final availabilityTime = widget.specialist.availableTimes
        .firstWhere((time) => time.day == dayName,
            orElse: () => AvailabilityTime(
                  day: dayName,
                  startTime: '09:00 AM',
                  endTime: '05:00 PM',
                ));

    // Generate time slots based on start and end time
    _availableTimeSlots = _generateTimeSlots(
      availabilityTime.startTime,
      availabilityTime.endTime,
    );

    // Reset selected time slot
    _selectedTimeSlot = null;
  }

  // Generate time slots in one-hour increments between start and end time
  List<String> _generateTimeSlots(String startTime, String endTime) {
    final format = DateFormat('hh:mm a');
    DateTime start;
    DateTime end;

    try {
      start = format.parse(startTime);
      end = format.parse(endTime);
    } catch (e) {
      // Try alternative format if parsing fails
      try {
        start = DateFormat('H:mm').parse(startTime);
        end = DateFormat('H:mm').parse(endTime);
      } catch (e) {
        // Default fallback
        start = DateTime(2022, 1, 1, 9, 0);
        end = DateTime(2022, 1, 1, 17, 0);
      }
    }

    final List<String> slots = [];
    DateTime current = start;

    // Add slots in one-hour increments
    while (current.isBefore(end)) {
      final slotEnd = current.add(const Duration(hours: 1));
      final slotText = '${format.format(current)} - ${format.format(slotEnd)}';
      slots.add(slotText);
      current = slotEnd;
    }

    return slots;
  }

  bool _isAvailableDay(DateTime date) {
    // Get the day name (e.g., "Monday")
    final dayName = DateFormat('EEEE').format(date);

    // Check if this day is in the specialist's available days
    return widget.specialist.availableTimes.any((time) => time.day == dayName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          // Content in scrollable area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Specialist info
                  _buildSpecialistInfo(),

                  const Divider(height: 32),

                  // Date selection
                  _buildDateSelection(),

                  const SizedBox(height: 24),

                  // Time selection
                  _buildTimeSelection(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Fixed bottom button
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Book Appointment',
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

  Widget _buildSpecialistInfo() {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: widget.specialist.photoUrl.isNotEmpty
                  ? NetworkImage(widget.specialist.photoUrl)
                  : null,
              child: widget.specialist.photoUrl.isEmpty
                  ? Text(widget.specialist.name[0].toUpperCase())
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.specialist.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.specialist.specialization,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${widget.specialist.price.toInt()} EGP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Text(
              'per session',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
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

        // Date picker
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 14, // Show 14 days
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isAvailable = _isAvailableDay(date);
              final isSelected = DateUtils.isSameDay(date, _selectedDate);

              return _buildDateCard(
                date: date,
                isAvailable: isAvailable,
                isSelected: isSelected,
                onTap: isAvailable
                    ? () {
                        final dayName = DateFormat('EEEE').format(date);
                        setState(() {
                          _selectedDate = date;
                          _updateAvailableTimeSlots(dayName);
                        });
                      }
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard({
    required DateTime date,
    required bool isAvailable,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(date, now);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.9)
              : isAvailable
                  ? Colors.white
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected || isAvailable
              ? [
                  BoxShadow(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.4)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : isAvailable
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date), // Mon, Tue, etc.
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.black
                        : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d').format(date), // 1, 2, etc.
              style: TextStyle(
                fontSize: 22,
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.black
                        : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isToday
                    ? isSelected
                        ? Colors.white.withOpacity(0.3)
                        : Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isToday
                    ? 'Today'
                    : DateFormat('MMM').format(date), // Jan, Feb, etc.
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? Theme.of(context).primaryColor
                          : isAvailable
                              ? Colors.black
                              : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelection() {
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
        if (_availableTimeSlots.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  'Working hours: ${_availableTimeSlots.first} - ${_availableTimeSlots.last}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
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
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No available time slots for this day',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please select another date',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 12,
      runSpacing: 16,
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

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed:
            _selectedTimeSlot != null ? () => _confirmBooking(context) : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Confirm Booking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${widget.specialist.price.toInt()} EGP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _confirmBooking(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the appointments repository and book without showing a loading indicator
      final appointmentsRepo = getIt<AppointmentsRepo>();

      await appointmentsRepo.bookAppointment(
        specialistId: widget.specialist.id,
        appointmentDate: _selectedDate,
        timeSlot: _selectedTimeSlot!,
      );

      // Format date for display
      final formattedDate =
          DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);

      setState(() {
        _isLoading = false;
      });

      // Close the bottom sheet
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Appointment Booked',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'With ${widget.specialist.name} on $formattedDate at $_selectedTimeSlot',
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'VIEW',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to appointments
            },
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error message without closing the sheet so they can try again
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book appointment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
