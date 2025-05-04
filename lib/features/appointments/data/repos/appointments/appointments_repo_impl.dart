// features/appointments/data/repos/appointments_repo_impl.dart
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

      // Create appointment model
      final appointment = AppointmentModel(
        id: appointmentId,
        specialistId: specialistId,
        appointmentDate: appointmentDate,
        timeSlot: timeSlot,
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
      } else {
        // Create user document if it doesn't exist
        await _firebaseService.firestore.collection('users').doc(userId).set({
          'appointments': [appointment.toMap()],
        });
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
      for (int i = 0; i < appointments.length; i++) {
        if (appointments[i]['id'] == appointmentId) {
          // Update appointment date and time slot
          appointments[i]['appointmentDate'] =
              Timestamp.fromDate(newAppointmentDate);
          appointments[i]['timeSlot'] = newTimeSlot;
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
          // Update status to cancelled
          appointments[i]['status'] = 'cancelled';
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
    } catch (e) {
      log('Error cancelling appointment: $e');
      rethrow;
    }
  }
}
