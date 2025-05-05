import 'package:esteshara/core/utils/app_colors.dart';
import 'package:esteshara/features/splash/presentation/views/widgets/splash_view_body.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: SplashViewBody(),
    );
  }
}
