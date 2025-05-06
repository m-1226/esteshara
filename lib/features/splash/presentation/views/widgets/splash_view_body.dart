import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/login_app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  static const String _hasSeenIntroKey = 'has_seen_intro';

  @override
  void initState() {
    super.initState();
    navigateToDashboard();
  }

  void navigateToDashboard() async {
    // Show splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    // Check if user has seen intro
    final hasSeenIntro = prefs.getBool(_hasSeenIntroKey) ?? false;

    // FIXED LOGIC: If user has NOT seen intro, navigate to intro
    if (!hasSeenIntro) {
      if (mounted) {
        context.pushReplacement(AppRouters.kIntroductionView);
      }
      return;
    }

    // If user has seen intro, continue with authentication flow
    if (!kIsWeb) {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        if (currentUser.emailVerified) {
          if (mounted) {
            context.pushReplacement(AppRouters.kHomeView);
          }
        } else {
          if (mounted) {
            context.pushReplacement(AppRouters.kLoginView);
          }
        }
      } else {
        if (mounted) {
          context.pushReplacement(AppRouters.kLoginView);
        }
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
          ),
        ],
      ),
    );
  }
}
