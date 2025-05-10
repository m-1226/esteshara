// features/specialists/presentation/managers/booking_manager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/models/user_model.dart';
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/home/data/manager/time_conflict_helper.dart';
import 'package:esteshara/features/home/data/models/availabitily_time.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Manager class that handles all business logic for booking appointments.
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
  bool _hasExistingAppointmentWithSpecialist = false;

  // Formatters
  final DateFormat _dayFormat = DateFormat('EEEE');

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
  bool get canConfirmBooking =>
      _selectedTimeSlot != null && !_hasExistingAppointmentWithSpecialist;
  bool get hasExistingAppointmentWithSpecialist =>
      _hasExistingAppointmentWithSpecialist;

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

          // Check if user already has an active appointment with this specialist
          _checkForExistingAppointmentWithSpecialist();
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

  // Check if the user already has an appointment with this specialist
  void _checkForExistingAppointmentWithSpecialist() {
    _hasExistingAppointmentWithSpecialist =
        TimeConflictHelper.hasExistingAppointmentWithSpecialist(
      specialistId: specialist.id,
      userAppointments: _userAppointments,
    );

    // If user has an existing appointment, show error message
    if (_hasExistingAppointmentWithSpecialist) {
      _errorMessage =
          'You already have an appointment with this specialist. Please cancel or reschedule it before booking another one.';
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
    // If user already has an appointment with this specialist,
    // don't bother calculating available time slots
    if (_hasExistingAppointmentWithSpecialist) {
      _availableTimeSlots = [];
      _selectedTimeSlot = null;
      return;
    }

    final availabilityTime = specialist.availableTimes.firstWhere(
      (time) => time.day == dayName,
      orElse: () => AvailabilityTime(
        day: dayName,
        startTime: '09:00 AM',
        endTime: '05:00 PM',
      ),
    );

    // Use TimeConflictHelper to generate available time slots
    // This filters out slots that conflict with existing appointments
    _availableTimeSlots = TimeConflictHelper.generateAvailableTimeSlots(
      date: _selectedDate,
      startTime: availabilityTime.startTime,
      endTime: availabilityTime.endTime,
      userAppointments: _userAppointments,
    );

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
    // If user already has an appointment with this specialist,
    // don't allow selecting any dates
    if (_hasExistingAppointmentWithSpecialist) {
      return false;
    }

    final dayName = _dayFormat.format(date);

    // Check if the day is in the specialist's available days
    if (!specialist.availableTimes.any((time) => time.day == dayName)) {
      return false;
    }

    // Get the availability time for this day
    final availabilityTime = specialist.availableTimes.firstWhere(
      (time) => time.day == dayName,
      orElse: () => AvailabilityTime(
        day: dayName,
        startTime: '09:00 AM',
        endTime: '05:00 PM',
      ),
    );

    // Generate time slots and check if any are available after conflict filtering
    final availableSlots = TimeConflictHelper.generateAvailableTimeSlots(
      date: date,
      startTime: availabilityTime.startTime,
      endTime: availabilityTime.endTime,
      userAppointments: _userAppointments,
    );

    return availableSlots.isNotEmpty;
  }

  // Check if user has conflicting appointments on a day
  bool hasConflictingAppointmentsOnDay(DateTime date) {
    final dayName = _dayFormat.format(date);

    // Get specialist's availability for this day
    final availabilityTime = specialist.availableTimes.firstWhere(
      (time) => time.day == dayName,
      orElse: () => AvailabilityTime(
        day: dayName,
        startTime: '09:00 AM',
        endTime: '05:00 PM',
      ),
    );

    // Generate all possible time slots
    final allTimeSlots = TimeConflictHelper.generateTimeSlots(
        availabilityTime.startTime, availabilityTime.endTime);

    // Check if all slots have conflicts
    final allHaveConflicts = allTimeSlots.every(
        (timeSlot) => TimeConflictHelper.hasConflictWithExistingAppointments(
              date: date,
              timeSlot: timeSlot,
              existingAppointments: _userAppointments,
            ));

    // Check if there are any appointments on this day
    final hasAppointmentsOnDay = _userAppointments.any((appointment) =>
        DateUtils.isSameDay(appointment.appointmentDate, date) &&
        (appointment.status == 'scheduled'));

    return hasAppointmentsOnDay && allHaveConflicts;
  }

  // Confirm booking
  Future<bool> confirmBooking() async {
    if (_selectedTimeSlot == null) return false;

    // If user already has an appointment with this specialist, prevent booking
    if (_hasExistingAppointmentWithSpecialist) {
      _errorMessage =
          'You already have an appointment with this specialist. Please cancel or reschedule it before booking another one.';
      _notifyStateChanged();
      return false;
    }

    // Double-check for conflicts before confirming
    if (TimeConflictHelper.hasConflictWithExistingAppointments(
      date: _selectedDate,
      timeSlot: _selectedTimeSlot!,
      existingAppointments: _userAppointments,
    )) {
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
      _hasExistingAppointmentWithSpecialist = true; // Update this flag
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

  // Notify state change
  void _notifyStateChanged() {
    onStateChanged();
  }
}
