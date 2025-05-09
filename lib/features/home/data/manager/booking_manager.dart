// features/specialists/presentation/managers/booking_manager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/models/user_model.dart';
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Manager class that handles all business logic for booking appointments.
/// Separates logic from UI for better maintainability.
class BookingManager {
  // Dependencies
  final SpecialistModel specialist;
  final AppointmentsRepo appointmentsRepo;
  final VoidCallback onStateChanged;

  // State
  bool _isLoading = true;
  bool _isSubmitting = false;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<String> _availableTimeSlots = [];
  List<AppointmentModel> _userAppointments = [];
  String _errorMessage = '';

  // Formatters
  final DateFormat _dayFormat = DateFormat('EEEE');
  final DateFormat _timeFormat = DateFormat('hh:mm a');

  // Constructor
  BookingManager({
    required this.specialist,
    required this.appointmentsRepo,
    required this.onStateChanged,
  });

  // Getters
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  DateTime get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  List<String> get availableTimeSlots => _availableTimeSlots;
  String get errorMessage => _errorMessage;
  bool get canConfirmBooking => _selectedTimeSlot != null;

  // Initialize
  Future<void> initialize() async {
    await _loadUserAppointments();
  }

  // Dispose resources if needed
  void dispose() {
    // Cleanup if needed
  }

  // Load user appointments to check for conflicts
  Future<void> _loadUserAppointments() async {
    _isLoading = true;
    _notifyStateChanged();

    try {
      final FirebaseService firebaseService = getIt<FirebaseService>();
      final User? currentUser = firebaseService.currentUser;

      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          final userData = UserModel.fromDocumentSnapshot(userDoc);
          _userAppointments = userData.appointments;
        }
      }

      _findNextAvailableDay();
      _isLoading = false;
      _notifyStateChanged();
    } catch (e) {
      debugPrint('Error loading user appointments: $e');
      _isLoading = false;
      _notifyStateChanged();
      _findNextAvailableDay();
    }
  }

  // Find the next available day for appointment
  void _findNextAvailableDay() {
    final availableDayNames =
        specialist.availableTimes.map((time) => time.day).toList();

    DateTime checkDate = DateTime.now();

    for (int i = 0; i < 14; i++) {
      final dayName = _dayFormat.format(checkDate);
      if (availableDayNames.contains(dayName)) {
        _selectedDate = checkDate;
        _updateAvailableTimeSlots(dayName);
        _notifyStateChanged();
        return;
      }
      checkDate = checkDate.add(const Duration(days: 1));
    }
  }

  // Update available time slots based on selected date
  void _updateAvailableTimeSlots(String dayName) {
    final availabilityTime = specialist.availableTimes.firstWhere(
      (time) => time.day == dayName,
      orElse: () => AvailabilityTime(
        day: dayName,
        startTime: '09:00 AM',
        endTime: '05:00 PM',
      ),
    );

    // Generate all time slots
    List<String> allTimeSlots = _generateTimeSlots(
      availabilityTime.startTime,
      availabilityTime.endTime,
    );

    // Filter slots for today
    List<String> filteredSlots = allTimeSlots;
    if (DateUtils.isSameDay(_selectedDate, DateTime.now())) {
      final now = DateTime.now();
      filteredSlots = allTimeSlots.where((timeSlot) {
        try {
          final startTimeString = timeSlot.split(' - ')[0];
          final slotDateTime = _parseTimeToToday(startTimeString);
          return slotDateTime.isAfter(now.add(const Duration(minutes: 30)));
        } catch (e) {
          return false;
        }
      }).toList();
    }

    // Filter out slots with conflicts
    _availableTimeSlots = filteredSlots.where((timeSlot) {
      return !_hasAppointmentConflict(_selectedDate, timeSlot);
    }).toList();

    _selectedTimeSlot = null;
  }

  // Public method to update selected date
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    final dayName = _dayFormat.format(date);
    _updateAvailableTimeSlots(dayName);
    _notifyStateChanged();
  }

  // Public method to select time slot
  void selectTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    _notifyStateChanged();
  }

  // Check if a date is available for booking
  bool isDateAvailable(DateTime date) {
    final dayName = _dayFormat.format(date);

    // Special handling for today
    if (DateUtils.isSameDay(date, DateTime.now())) {
      final availabilityTime = specialist.availableTimes.firstWhere(
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
          return slotDateTime.isAfter(now.add(const Duration(minutes: 30))) &&
              !_hasAppointmentConflict(date, timeSlot);
        } catch (e) {
          return false;
        }
      });

      return specialist.availableTimes.any((time) => time.day == dayName) &&
          hasAvailableSlots;
    }

    // For future dates
    final availabilityTime = specialist.availableTimes.firstWhere(
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

    // Check if there's at least one slot without conflict
    final hasAvailableSlot = allTimeSlots
        .any((timeSlot) => !_hasAppointmentConflict(date, timeSlot));

    return specialist.availableTimes.any((time) => time.day == dayName) &&
        hasAvailableSlot;
  }

  // Check if user has conflicting appointments on a day
  bool hasConflictingAppointmentsOnDay(DateTime date) {
    final dayName = _dayFormat.format(date);
    final availabilityTime = specialist.availableTimes.firstWhere(
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

    // Check if all slots have conflicts
    final allHaveConflicts = allTimeSlots
        .every((timeSlot) => _hasAppointmentConflict(date, timeSlot));

    // Check if there are any appointments on this day
    final hasAppointmentsOnDay = _userAppointments.any((appointment) =>
        DateUtils.isSameDay(appointment.appointmentDate, date) &&
        (appointment.status == 'scheduled'));

    return hasAppointmentsOnDay && allHaveConflicts;
  }

  // Confirm booking
  Future<bool> confirmBooking() async {
    if (_selectedTimeSlot == null) return false;

    // Double-check for conflicts before confirming
    if (_hasAppointmentConflict(_selectedDate, _selectedTimeSlot!)) {
      _errorMessage =
          'This time slot is no longer available - you may have a conflicting appointment';

      // Refresh available time slots
      final dayName = _dayFormat.format(_selectedDate);
      _updateAvailableTimeSlots(dayName);
      _notifyStateChanged();
      return false;
    }

    _isSubmitting = true;
    _notifyStateChanged();

    try {
      await appointmentsRepo.bookAppointment(
        specialistId: specialist.id,
        appointmentDate: _selectedDate,
        timeSlot: _selectedTimeSlot!,
      );

      // Update local list of appointments to prevent double-booking
      final newAppointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        specialistId: specialist.id,
        appointmentDate: _selectedDate,
        timeSlot: _selectedTimeSlot!,
        status: 'scheduled',
      );

      _userAppointments.add(newAppointment);
      _isSubmitting = false;
      _notifyStateChanged();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSubmitting = false;
      _notifyStateChanged();
      return false;
    }
  }

  // Helper to check for appointment conflicts
  bool _hasAppointmentConflict(DateTime date, String timeSlot) {
    // Only check conflicts for active appointments
    final activeAppointments = _userAppointments
        .where((appointment) => appointment.status == 'scheduled')
        .toList();

    if (activeAppointments.isEmpty) return false;

    // Parse time slot
    final timeRange = timeSlot.split(' - ');
    final slotStartTime = _parseTimeString(timeRange[0]);
    final slotEndTime = _parseTimeString(timeRange[1]);

    // Create full DateTime objects for potential appointment
    final slotStartDateTime = DateTime(date.year, date.month, date.day,
        slotStartTime.hour, slotStartTime.minute);
    final slotEndDateTime = DateTime(
        date.year, date.month, date.day, slotEndTime.hour, slotEndTime.minute);

    // Check for overlaps with existing appointments
    for (final appointment in activeAppointments) {
      if (DateUtils.isSameDay(appointment.appointmentDate, date)) {
        try {
          // Parse the appointment time slot
          final appointmentTimeRange = appointment.timeSlot.split(' - ');
          final appointmentStartTime =
              _parseTimeString(appointmentTimeRange[0]);
          final appointmentEndTime = _parseTimeString(appointmentTimeRange[1]);

          // Create DateTime objects for existing appointment
          final appointmentStartDateTime = DateTime(date.year, date.month,
              date.day, appointmentStartTime.hour, appointmentStartTime.minute);
          final appointmentEndDateTime = DateTime(date.year, date.month,
              date.day, appointmentEndTime.hour, appointmentEndTime.minute);

          // Check for overlap
          if ((slotStartDateTime.isBefore(appointmentEndDateTime) ||
                  slotStartDateTime.isAtSameMomentAs(appointmentEndDateTime)) &&
              (slotEndDateTime.isAfter(appointmentStartDateTime) ||
                  slotEndDateTime.isAtSameMomentAs(appointmentStartDateTime))) {
            return true; // Overlap detected
          }
        } catch (e) {
          debugPrint('Error parsing appointment time: $e');
        }
      }
    }

    return false;
  }

  // Helper method to generate time slots
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

  // Helper to parse time string to TimeOfDay
  TimeOfDay _parseTimeString(String timeString) {
    try {
      final dateTime = _timeFormat.parse(timeString);
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } catch (e) {
      try {
        final dateTime = DateFormat('H:mm').parse(timeString);
        return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      } catch (e) {
        return const TimeOfDay(hour: 9, minute: 0);
      }
    }
  }

  // Helper to parse time to today's date
  DateTime _parseTimeToToday(String timeString) {
    final now = DateTime.now();
    final time = _timeFormat.parse(timeString);
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  // Notify state change
  void _notifyStateChanged() {
    onStateChanged();
  }
}
