// features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esteshara/core/models/appointment_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final List<String> favoriteSpecialistIds;
  final List<AppointmentModel> appointments;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    List<String>? favoriteSpecialistIds,
    List<AppointmentModel>? appointments,
  })  : favoriteSpecialistIds = favoriteSpecialistIds ?? [],
        appointments = appointments ?? [];

  // Create from Firestore document
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Use the id from the document data if available, otherwise use the document id
    final userId = data['id'] ?? doc.id;

    List<AppointmentModel> appointments = [];
    if (data['appointments'] != null) {
      appointments = List<Map<String, dynamic>>.from(data['appointments'])
          .map((appointmentMap) => AppointmentModel.fromMap(appointmentMap))
          .toList();
    }

    return UserModel(
      id: userId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      favoriteSpecialistIds:
          List<String>.from(data['favoriteSpecialistIds'] ?? []),
      appointments: appointments,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Store the id in the document
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'favoriteSpecialistIds': favoriteSpecialistIds,
      'appointments':
          appointments.map((appointment) => appointment.toMap()).toList(),
    };
  }

  // Add a new appointment
  UserModel addAppointment({
    required String appointmentId,
    required String specialistId,
    required DateTime date,
    required String timeSlot,
  }) {
    final newAppointment = AppointmentModel(
      id: appointmentId,
      specialistId: specialistId,
      appointmentDate: date,
      timeSlot: timeSlot,
    );

    final updatedAppointments = List<AppointmentModel>.from(appointments)
      ..add(newAppointment);

    return UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      favoriteSpecialistIds: favoriteSpecialistIds,
      appointments: updatedAppointments,
    );
  }

  // Cancel an appointment
  UserModel cancelAppointment(String appointmentId) {
    final updatedAppointments = appointments.map((appointment) {
      if (appointment.id == appointmentId) {
        return AppointmentModel(
          id: appointment.id,
          specialistId: appointment.specialistId,
          appointmentDate: appointment.appointmentDate,
          timeSlot: appointment.timeSlot,
          status: "cancelled",
        );
      }
      return appointment;
    }).toList();

    return UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      favoriteSpecialistIds: favoriteSpecialistIds,
      appointments: updatedAppointments,
    );
  }

  // Get all upcoming appointments
  List<AppointmentModel> getUpcomingAppointments() {
    final now = DateTime.now();
    return appointments.where((appointment) {
      return appointment.status == "scheduled" &&
          appointment.appointmentDate.isAfter(now);
    }).toList();
  }

  // Toggle favorite specialist
  UserModel toggleFavoriteSpecialist(String specialistId) {
    List<String> updatedFavorites = List<String>.from(favoriteSpecialistIds);

    if (updatedFavorites.contains(specialistId)) {
      updatedFavorites.remove(specialistId);
    } else {
      updatedFavorites.add(specialistId);
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      favoriteSpecialistIds: updatedFavorites,
      appointments: appointments,
    );
  }
}
