// features/specialists/data/models/specialist_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esteshara/features/home/data/models/availabitily_time.dart';

class SpecialistModel {
  final String id;
  final String name;
  final String specialization;
  final String bio;
  final String photoUrl;
  final List<AvailabilityTime> availableTimes;
  final double price;
  final double rating;
  final int reviewCount;

  SpecialistModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.bio,
    required this.photoUrl,
    required this.availableTimes,
    this.price = 300.0,
    this.rating = 4.5,
    this.reviewCount = 0,
  });

  factory SpecialistModel.fromMap(Map<String, dynamic> map, String docId) {
    return SpecialistModel(
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
      price: (map['price'] ?? 300.0).toDouble(),
      rating: (map['rating'] ?? 4.5).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  factory SpecialistModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return SpecialistModel.fromMap(
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
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
