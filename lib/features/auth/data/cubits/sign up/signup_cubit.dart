import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepo authRepo;

  SignUpCubit({required this.authRepo}) : super(SignupInitial());

  Future<void> signUp(String email, String password, String username) async {
    emit(SignUpLoading());

    try {
      User? user =
          await authRepo.signUpWithEmailAndPassword(email, password, username);

      if (user != null) {
        emit(SignUpSuccess());
      } else {
        emit(SignUpFailure(errMessage: 'Failed to create account'));
      }
    } on FirebaseAuthException catch (e) {
      if (!isClosed) {
        if (e.code == 'email-already-in-use') {
          emit(SignUpFailure(errMessage: 'هذا الإيميل مستخدم'));
        } else if (e.code == 'weak-password') {
          emit(SignUpFailure(errMessage: 'كلمة المرور ضعيفة'));
        } else if (e.code == 'invalid-email') {
          emit(SignUpFailure(errMessage: 'الإيميل غير صالح'));
        } else {
          emit(SignUpFailure(errMessage: 'خطأ في التسجيل: ${e.message}'));
        }
      }
    } catch (e) {
      debugPrint('Error during sign-up: $e');
      if (!isClosed) {
        emit(SignUpFailure(errMessage: 'حدث خطأ أثناء إنشاء الحساب'));
      }
    }
  }
}
