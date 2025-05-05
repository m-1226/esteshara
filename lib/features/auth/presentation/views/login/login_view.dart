import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/core/widgets/errors/custom_error_message.dart';
import 'package:esteshara/features/auth/data/cubits/login/login_cubit.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/login_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(authRepo: getIt<AuthRepo>()),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            context.pushReplacement(AppRouters.kHomeView);
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
