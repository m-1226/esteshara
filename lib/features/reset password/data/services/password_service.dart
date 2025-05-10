import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> doesEmailExistInFirestore(String email) async {
    final usersCollection = _firestore.collection('users');
    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }
}
