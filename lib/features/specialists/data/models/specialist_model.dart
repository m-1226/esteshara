// features/specialists/data/models/specialist_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityTime {
  final String day;
  final String startTime;
  final String endTime;

  AvailabilityTime({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory AvailabilityTime.fromMap(Map<String, dynamic> map) {
    return AvailabilityTime(
      day: map['day'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class Specialist {
  final String id;
  final String name;
  final String specialization;
  final String bio;
  final String photoUrl;
  final List<AvailabilityTime> availableTimes;

  Specialist({
    required this.id,
    required this.name,
    required this.specialization,
    required this.bio,
    required this.photoUrl,
    required this.availableTimes,
  });

  factory Specialist.fromMap(Map<String, dynamic> map, String docId) {
    return Specialist(
      id: docId,
      name: map['name'] ?? '',
      specialization: map['specialization'] ?? '',
      bio: map['bio'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      availableTimes: List<AvailabilityTime>.from(
        (map['availableTimes'] ?? []).map(
          (x) => AvailabilityTime.fromMap(x),
        ),
      ),
    );
  }

  factory Specialist.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Specialist.fromMap(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
      'bio': bio,
      'photoUrl': photoUrl,
      'availableTimes': availableTimes.map((x) => x.toMap()).toList(),
    };
  }
}
