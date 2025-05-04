// features/auth/data/repos/auth/auth_repo_impl.dart
import 'dart:developer';

import 'package:esteshara/core/models/user_model.dart';
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseService _firebaseService;

  // Constructor with dependency injection
  AuthRepoImpl({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  /// ✅ Login with Email & Password
  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user != null && user.emailVerified) {
        return user;
      }
      return null;
    } catch (e) {
      log("Error during email login: $e");
      rethrow;
    }
  }

  /// ✅ Sign Up with Email & Password
  @override
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await _firebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user != null) {
        // Send email verification
        await user.sendEmailVerification();

        // Create a User model
        final UserModel userModel = UserModel(
          id: user.uid,
          name: username.trimRight(),
          email: email,
          photoUrl: user.photoURL,
          favoriteSpecialistIds: [],
          appointments: [],
        );

        // Store user data in Firestore
        await _firebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        return user;
      }
      return null;
    } catch (e) {
      log("Error during signup: $e");
      rethrow;
    }
  }

  /// ✅ Sign in with Google
  @override
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception("User has cancelled login with Google");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
          await _firebaseService.auth.signInWithCredential(credential);

      // Get the user
      final User? user = userCredential.user;

      // If sign in was successful, create or update user in Firestore
      if (user != null) {
        // Check if user exists in Firestore
        final userDoc = await _firebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // New user - create user record
          final UserModel userModel = UserModel(
            id: user.uid,
            name: user.displayName ?? 'User',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            favoriteSpecialistIds: [],
            appointments: [],
          );

          await _firebaseService.firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
        }
      }

      return user;
    } catch (e) {
      log("Error during Google sign-in: $e");
      throw Exception(e.toString());
    }
  }

  /// ✅ Sign Out
  @override
  Future<void> signOut() async {
    try {
      // Sign out from Google if signed in
      final user = _firebaseService.currentUser;
      if (user != null) {
        for (final provider in user.providerData) {
          if (provider.providerId == 'google.com') {
            await GoogleSignIn().signOut();
            log('Google Sign-Out successful for user ${user.uid}');
          }
        }
      }

      // Sign out from Firebase
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
