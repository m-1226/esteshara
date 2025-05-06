// features/appointments/data/repos/appointments/appointments_repo_impl.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:uuid/uuid.dart';

class AppointmentsRepoImpl implements AppointmentsRepo {
  final FirebaseService _firebaseService;

  AppointmentsRepoImpl({
    required FirebaseService firebaseService,
  }) : _firebaseService = firebaseService;

  @override
  Future<List<AppointmentModel>> getUserAppointments() async {
    try {
      // Get current user ID
      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get user document
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        return [];
      }

      // Get user data
      final userData = userDoc.data() as Map<String, dynamic>;

      // Convert appointments data to model objects
      if (userData['appointments'] != null) {
        final appointments = (userData['appointments'] as List)
            .map((appointmentData) => AppointmentModel.fromMap(
                appointmentData as Map<String, dynamic>))
            .toList();

        return appointments;
      }

      return [];
    } catch (e) {
      log('Error fetching appointments: $e');
      rethrow;
    }
  }

  @override
  Stream<List<AppointmentModel>> getAppointmentsStream() {
    try {
      // Get current user ID
      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Return a stream that updates when the document changes
      return _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists) {
          return [];
        }

        final userData = snapshot.data() as Map<String, dynamic>;

        if (userData['appointments'] == null) {
          return [];
        }

        final appointments = (userData['appointments'] as List)
            .map((appointmentData) => AppointmentModel.fromMap(
                appointmentData as Map<String, dynamic>))
            .toList();

        log('Appointments stream received ${appointments.length} appointments');
        return appointments;
      });
    } catch (e) {
      log('Error setting up appointments stream: $e');
      // For streams, we need to convert the error to a stream error
      return Stream.error(e);
    }
  }

  @override
  Future<String> bookAppointment({
    required String specialistId,
    required DateTime appointmentDate,
    required String timeSlot,
  }) async {
    try {
      // Get current user ID
      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Generate unique ID for appointment
      final appointmentId = const Uuid().v4();

      // Create appointment model with current timestamp
      final appointment = AppointmentModel(
        id: appointmentId,
        specialistId: specialistId,
        appointmentDate: appointmentDate,
        timeSlot: timeSlot,
        createdAt: DateTime.now(), // Set creation time explicitly
      );

      // Get user document
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      // Add appointment to user document
      if (userDoc.exists) {
        await _firebaseService.firestore
            .collection('users')
            .doc(userId)
            .update({
          'appointments': FieldValue.arrayUnion([appointment.toMap()]),
        });

        log('Appointment booked with ID: $appointmentId');
      } else {
        // Create user document if it doesn't exist
        await _firebaseService.firestore.collection('users').doc(userId).set({
          'appointments': [appointment.toMap()],
        });

        log('User document created and appointment booked with ID: $appointmentId');
      }

      return appointmentId;
    } catch (e) {
      log('Error booking appointment: $e');
      rethrow;
    }
  }

  @override
  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newAppointmentDate,
    required String newTimeSlot,
  }) async {
    try {
      // Get current user ID
      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get user document with appointments
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Get existing appointments
      final appointments =
          List<Map<String, dynamic>>.from(userData['appointments'] ?? []);

      // Find the appointment to reschedule
      bool found = false;
      int appointmentIndex = -1;

      for (int i = 0; i < appointments.length; i++) {
        if (appointments[i]['id'] == appointmentId) {
          appointmentIndex = i;
          found = true;
          break;
        }
      }

      if (!found) {
        throw Exception('Appointment not found');
      }

      // Convert to AppointmentModel to validate rescheduling eligibility
      final currentAppointment =
          AppointmentModel.fromMap(appointments[appointmentIndex]);

      // Verify the appointment can be rescheduled
      if (!currentAppointment.canReschedule()) {
        throw Exception(
            'Appointment is no longer eligible for rescheduling. Rescheduling must be done within 2 hours of booking.');
      }

      // Update appointment with new date, time, and lastModified
      appointments[appointmentIndex]['appointmentDate'] =
          Timestamp.fromDate(newAppointmentDate);
      appointments[appointmentIndex]['timeSlot'] = newTimeSlot;
      appointments[appointmentIndex]['lastModified'] =
          Timestamp.fromDate(DateTime.now());

      // Update user document with modified appointments
      await _firebaseService.firestore.collection('users').doc(userId).update({
        'appointments': appointments,
      });

      log('Appointment rescheduled: $appointmentId');
    } catch (e) {
      log('Error rescheduling appointment: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      // Get current user ID
      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get user document with appointments
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Get existing appointments
      final appointments =
          List<Map<String, dynamic>>.from(userData['appointments'] ?? []);

      // Find the appointment to cancel
      bool found = false;
      for (int i = 0; i < appointments.length; i++) {
        if (appointments[i]['id'] == appointmentId) {
          // Update status to cancelled and add lastModified timestamp
          appointments[i]['status'] = 'cancelled';
          appointments[i]['lastModified'] = Timestamp.fromDate(DateTime.now());
          found = true;
          break;
        }
      }

      if (!found) {
        throw Exception('Appointment not found');
      }

      // Update user document with modified appointments
      await _firebaseService.firestore.collection('users').doc(userId).update({
        'appointments': appointments,
      });

      log('Appointment cancelled: $appointmentId');
    } catch (e) {
      log('Error cancelling appointment: $e');
      rethrow;
    }
  }
}
