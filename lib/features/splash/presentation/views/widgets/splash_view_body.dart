import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/login_app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    navigateToDashboard();
  }

  void navigateToDashboard() async {
    if (!kIsWeb) {
      await Future.delayed(const Duration(seconds: 3));

      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        if (currentUser.emailVerified) {
          context.pushReplacement(AppRouters.kHomeView);
        } else {
          context.pushReplacement(AppRouters.kLoginView);
        }
      } else {
        context.pushReplacement(AppRouters.kLoginView);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginAppLogo(
            imageSize: 350,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
