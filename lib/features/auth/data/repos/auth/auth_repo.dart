import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<User?> loginWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username);
  Future<void> signOut();
}
