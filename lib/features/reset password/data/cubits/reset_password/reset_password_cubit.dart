import 'package:esteshara/features/reset%20password/data/cubits/reset_password/reset_password_states.dart';
import 'package:esteshara/features/reset%20password/data/services/password_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword(String email) async {
    final PasswordResetService passwordResetService = PasswordResetService();
    emit(ResetPasswordLoading());
    final auth = FirebaseAuth.instance;
    try {
      final emailExists =
          await passwordResetService.doesEmailExistInFirestore(email);

      if (emailExists) {
        await auth.sendPasswordResetEmail(email: email);
        emit(ResetPasswordSuccess());
      } else {
        emit(ResetPasswordFailure(errMessage: 'هذا الإيميل غير موجود'));
      }
    } catch (error) {
      if (!isClosed) {
        emit(ResetPasswordFailure(errMessage: 'Error sending reset email'));
      }
    }
  }
}
