part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginGoogleLoading extends LoginState {}

final class LoginAppleLoading extends LoginState {}

final class LoginFacebookLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailure extends LoginState {
  final String errMessage;

  LoginFailure({required this.errMessage});
}

final class LoginBlocked extends LoginState {
  final String errMessage;

  LoginBlocked({required this.errMessage});
}
