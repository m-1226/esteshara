// features/specialists/data/repos/specialist_repo_impl.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
import 'package:esteshara/features/specialists/data/repos/spcialists/specialist_repo.dart';

class SpecialistRepoImpl implements SpecialistRepo {
  final FirebaseService _firebaseService;

  SpecialistRepoImpl({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  @override
  Future<List<SpecialistModel>> getAllSpecialists() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firebaseService.firestore.collection('specialists').get();

      return querySnapshot.docs
          .map((doc) => SpecialistModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      log('Error fetching specialists: $e');
      return [];
    }
  }

  @override
  Future<List<SpecialistModel>> getSpecialistsBySpecialization(
      String specialization) async {
    try {
      final QuerySnapshot querySnapshot = await _firebaseService.firestore
          .collection('specialists')
          .where('specialization', isEqualTo: specialization)
          .get();

      return querySnapshot.docs
          .map((doc) => SpecialistModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      log('Error fetching specialists by specialization: $e');
      return [];
    }
  }

  @override
  Future<SpecialistModel?> getSpecialistById(String id) async {
    try {
      final DocumentSnapshot docSnapshot = await _firebaseService.firestore
          .collection('specialists')
          .doc(id)
          .get();

      if (docSnapshot.exists) {
        return SpecialistModel.fromDocumentSnapshot(docSnapshot);
      }
      return null;
    } catch (e) {
      log('Error fetching specialist by ID: $e');
      return null;
    }
  }
}
