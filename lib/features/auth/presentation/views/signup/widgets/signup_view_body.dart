import 'package:esteshara/features/auth/presentation/views/login/widgets/login_app_logo.dart';
import 'package:esteshara/features/auth/presentation/views/signup/widgets/signup_form.dart';
import 'package:flutter/material.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: Column(
        children: [
          LoginAppLogo(),
          SignUpForm(),
        ],
      ),
    );
  }
}
