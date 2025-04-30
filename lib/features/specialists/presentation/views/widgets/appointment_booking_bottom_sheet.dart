// features/specialists/presentation/widgets/appointment_booking_bottom_sheet.dart
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
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
  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM'
  ];

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
        });
        return;
      }

      // Try the next day
      checkDate = checkDate.add(const Duration(days: 1));
    }

    // If no available day found, keep today's date
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
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
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
          ),
          const SizedBox(height: 16),

          // Specialist info
          Row(
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
              const SizedBox(width: 12),
              Column(
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
            ],
          ),

          const Divider(height: 32),

          // Date selection
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
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 14, // Show 14 days
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isAvailable = _isAvailableDay(date);
                final isSelected = DateUtils.isSameDay(date, _selectedDate);

                return GestureDetector(
                  onTap: isAvailable
                      ? () {
                          setState(() {
                            _selectedDate = date;
                            _selectedTimeSlot = null; // Reset time selection
                          });
                        }
                      : null,
                  child: Container(
                    width: 65,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.8)
                          : isAvailable
                              ? Colors.grey.shade100
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
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
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('d').format(date), // 1, 2, etc.
                          style: TextStyle(
                            fontSize: 20,
                            color: isSelected
                                ? Colors.white
                                : isAvailable
                                    ? Colors.black
                                    : Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM').format(date), // Jan, Feb, etc.
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : isAvailable
                                    ? Colors.black
                                    : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Time selection
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
          const SizedBox(height: 16),

          // Time slots
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: _timeSlots.map((time) {
              final isSelected = _selectedTimeSlot == time;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeSlot = time;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedTimeSlot != null
                  ? () => _confirmBooking(context)
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Add some extra space for iOS devices with home indicator
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  void _confirmBooking(BuildContext context) {
    // Format the date and time for display
    final formattedDate =
        DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);

    // Close the bottom sheet
    Navigator.pop(context);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Appointment booked with ${widget.specialist.name} on $formattedDate at $_selectedTimeSlot'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );

    // Here you would typically save the appointment to your backend
    // and navigate to an appointment confirmation or list screen
  }
}
