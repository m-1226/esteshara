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
  final DateFormat _dayFormat = DateFormat('EEEE');
  final DateFormat _timeFormat = DateFormat('hh:mm a');

  @override
  void initState() {
    super.initState();
    _findNextAvailableDay();
  }

  void _findNextAvailableDay() {
    final availableDayNames =
        widget.specialist.availableTimes.map((time) => time.day).toList();
    DateTime checkDate = DateTime.now();

    for (int i = 0; i < 14; i++) {
      final dayName = _dayFormat.format(checkDate);
      if (availableDayNames.contains(dayName)) {
        setState(() {
          _selectedDate = checkDate;
          _updateAvailableTimeSlots(dayName);
        });
        return;
      }
      checkDate = checkDate.add(const Duration(days: 1));
    }
  }

  void _updateAvailableTimeSlots(String dayName) {
    final availabilityTime = widget.specialist.availableTimes.firstWhere(
      (time) => time.day == dayName,
      orElse: () => AvailabilityTime(
        day: dayName,
        startTime: '09:00 AM',
        endTime: '05:00 PM',
      ),
    );

    // Generate all time slots first
    List<String> allTimeSlots = _generateTimeSlots(
      availabilityTime.startTime,
      availabilityTime.endTime,
    );

    // Filter time slots if selected date is today
    if (DateUtils.isSameDay(_selectedDate, DateTime.now())) {
      final now = DateTime.now();

      // Filter out past time slots for today
      _availableTimeSlots = allTimeSlots.where((timeSlot) {
        try {
          // Extract the start time from the slot (e.g. "09:00 AM - 10:00 AM" -> "09:00 AM")
          final startTimeString = timeSlot.split(' - ')[0];
          final slotDateTime = _parseTimeToToday(startTimeString);

          // Add a buffer (e.g., 30 min) to the current time to ensure users can't book appointments starting too soon
          final bookingCutoffTime = now.add(const Duration(minutes: 30));

          // Only include this slot if it starts after the cutoff time
          return slotDateTime.isAfter(bookingCutoffTime);
        } catch (e) {
          // If there's an error parsing, exclude the slot to be safe
          return false;
        }
      }).toList();
    } else {
      // For future dates, all slots are available
      _availableTimeSlots = allTimeSlots;
    }

    _selectedTimeSlot = null;
  }

  /// Helper method to parse a time string to a DateTime for today
  DateTime _parseTimeToToday(String timeString) {
    final now = DateTime.now();
    final time = _timeFormat.parse(timeString);
    return DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
  }

  List<String> _generateTimeSlots(String startTime, String endTime) {
    DateTime start;
    DateTime end;

    try {
      start = _timeFormat.parse(startTime);
      end = _timeFormat.parse(endTime);
    } catch (e) {
      try {
        start = DateFormat('H:mm').parse(startTime);
        end = DateFormat('H:mm').parse(endTime);
      } catch (e) {
        start = DateTime(2022, 1, 1, 9, 0);
        end = DateTime(2022, 1, 1, 17, 0);
      }
    }

    final List<String> slots = [];
    DateTime current = start;

    while (current.isBefore(end)) {
      final slotEnd = current.add(const Duration(hours: 1));
      final slotText =
          '${_timeFormat.format(current)} - ${_timeFormat.format(slotEnd)}';
      slots.add(slotText);
      current = slotEnd;
    }

    return slots;
  }

  bool _isAvailableDay(DateTime date) {
    final dayName = _dayFormat.format(date);

    // If it's today, only consider it available if there are available time slots left
    if (DateUtils.isSameDay(date, DateTime.now())) {
      final availabilityTime = widget.specialist.availableTimes.firstWhere(
        (time) => time.day == dayName,
        orElse: () => AvailabilityTime(
          day: dayName,
          startTime: '09:00 AM',
          endTime: '05:00 PM',
        ),
      );

      final allTimeSlots = _generateTimeSlots(
        availabilityTime.startTime,
        availabilityTime.endTime,
      );

      // Check if any slots are still available today
      final now = DateTime.now();
      final hasAvailableSlots = allTimeSlots.any((timeSlot) {
        try {
          final startTimeString = timeSlot.split(' - ')[0];
          final slotDateTime = _parseTimeToToday(startTimeString);
          return slotDateTime.isAfter(now.add(const Duration(minutes: 30)));
        } catch (e) {
          return false;
        }
      });

      return widget.specialist.availableTimes
              .any((time) => time.day == dayName) &&
          hasAvailableSlots;
    }

    // For future dates, just check if the day is available
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
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSpecialistInfo(),
                  const Divider(height: 32),
                  _buildDateSelection(),
                  const SizedBox(height: 24),
                  _buildTimeSelection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSpecialistAvatar(),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.specialist.specialization,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildPriceInfo(),
      ],
    );
  }

  Widget _buildSpecialistAvatar() {
    return Stack(
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
    );
  }

  Widget _buildPriceInfo() {
    return Column(
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
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 14,
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
                        final dayName = _dayFormat.format(date);
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.9)
              : isAvailable
                  ? Colors.white
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected || isAvailable
              ? [
                  BoxShadow(
                    color: isSelected
                        ? theme.primaryColor.withOpacity(0.4)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : isAvailable
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
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
              DateFormat('d').format(date),
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
                        : theme.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isToday ? 'Today' : DateFormat('MMM').format(date),
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? theme.primaryColor
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
        _buildTimeSelectionHeader(),
        const SizedBox(height: 8),
        if (_availableTimeSlots.isNotEmpty) _buildWorkingHoursInfo(),
        _availableTimeSlots.isEmpty
            ? _buildNoTimeSlotsMessage()
            : _buildTimeSlots(),
      ],
    );
  }

  Widget _buildTimeSelectionHeader() {
    return Row(
      children: [
        const Text(
          'Select Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            DateFormat('EEEE, MMM d').format(_selectedDate),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkingHoursInfo() {
    // Get the actual working hours based on filtered available slots
    String workingHoursText = "";

    if (_availableTimeSlots.isNotEmpty) {
      final firstSlotStart = _availableTimeSlots.first.split(' - ')[0];
      final lastSlotEnd = _availableTimeSlots.last.split(' - ')[1];
      workingHoursText = '$firstSlotStart - $lastSlotEnd';

      // If today, add note about filtering
      if (DateUtils.isSameDay(_selectedDate, DateTime.now())) {
        workingHoursText += ' (remaining today)';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Available hours: $workingHoursText',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoTimeSlotsMessage() {
    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());

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
              isToday
                  ? 'No more available time slots for today'
                  : 'No available time slots for this day',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isToday
                  ? 'Please select tomorrow or another date'
                  : 'Please select another date',
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

  Future<void> _confirmBooking(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appointmentsRepo = getIt<AppointmentsRepo>();
      await appointmentsRepo.bookAppointment(
        specialistId: widget.specialist.id,
        appointmentDate: _selectedDate,
        timeSlot: _selectedTimeSlot!,
      );

      final formattedDate =
          DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
      _showSuccessMessage(context, formattedDate);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage(context, e.toString());
    }
  }

  void _showSuccessMessage(BuildContext context, String formattedDate) {
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
  }

  void _showErrorMessage(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to book appointment: $errorMessage'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
