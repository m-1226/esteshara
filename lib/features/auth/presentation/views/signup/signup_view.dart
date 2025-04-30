import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Signup View',
          style: AppStyles.regular14,
        ),
      ),
    );
  }
}
