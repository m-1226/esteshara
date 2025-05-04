import 'package:esteshara/features/auth/presentation/views/login/widgets/login_app_logo.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginAppLogo(),
              Gap(10),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
