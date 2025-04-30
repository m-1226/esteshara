import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseService _firebaseService;

  // Constructor with dependency injection
  AuthRepoImpl({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  /// ✅ Login with Email & Password
  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseService.auth
        .signInWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    if (user != null && user.emailVerified) {
      return user;
    }
    return null;
  }

  /// ✅ Sign Up with Email & Password
  @override
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    UserCredential userCredential = await _firebaseService.auth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;

    if (user != null) {
      // Send email verification
      await user.sendEmailVerification();

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'email': email,
        'username': username.trimRight(),
        'isVerified': false,
        'registrationDate': DateTime.now(),
      });

      return user;
    }

    return null;
  }

  /// ✅ Sign Out
  @override
  Future<void> signOut() async {
    try {
      await _firebaseService.auth.signOut();
      log('Firebase Auth Sign-Out successful');
    } on FirebaseAuthException catch (e) {
      log('Sign-out error: ${e.code}: ${e.message}');
      rethrow;
    } catch (e) {
      log('Unexpected error during sign-out: $e');
      rethrow;
    }
  }
}
