import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/core/widgets/errors/custom_error_message.dart';
import 'package:esteshara/features/auth/data/cubits/login/login_cubit.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/login_view_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
    navigateToDashboard();
  }

  void navigateToDashboard() async {
    if (!kIsWeb) {
      await Future.delayed(const Duration(seconds: 1));

      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        if (currentUser.emailVerified) {
          context.pushReplacement(AppRouters.kSpecialistsView);
        } else {
          context.go(AppRouters.kLoginView);
        }
      } else {
        context.go(AppRouters.kLoginView);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(authRepo: getIt<AuthRepo>()),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            context.pushReplacement(AppRouters.kSpecialistsView);
          } else if (state is LoginFailure) {
            customErrorMessage(title: state.errMessage);
          }
        },
        builder: (context, state) {
          return const Scaffold(
            body: SingleChildScrollView(
              child: LoginViewBody(),
            ),
          );
        },
      ),
    );
  }
}
