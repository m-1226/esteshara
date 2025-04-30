import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Login View',
          style: AppStyles.regular14,
        ),
      ),
    );
  }
}
