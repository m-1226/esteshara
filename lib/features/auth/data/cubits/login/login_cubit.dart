import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit({required this.authRepo}) : super(LoginInitial());

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(LoginLoading());
    try {
      User? user = await authRepo.loginWithEmailAndPassword(email, password);
      if (user!.emailVerified) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(errMessage: 'برجاء تفعيل الإيميل الخاص بك'));
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'invalid-credentials') {
        emit(LoginFailure(errMessage: 'الإيميل أو كلمة المرور غير صحيح'));
      } else if (ex.code == 'user-disabled') {
        emit(LoginFailure(errMessage: 'تم تعطيل حسابك تواصل مع الإدارة.'));
      } else {
        emit(LoginFailure(errMessage: 'خطأ أثناء تسجيل الدخول: ${ex.message}'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: e.toString()));
    }
  }
}
