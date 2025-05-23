// core/utils/app_routers.dart
import 'package:esteshara/features/app%20navigator/presentation/views/app_navigator.dart';
import 'package:esteshara/features/appointments/presentation/views/appointments_view.dart';
import 'package:esteshara/features/auth/presentation/views/login/login_view.dart';
import 'package:esteshara/features/auth/presentation/views/signup/signup_view.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/home_view.dart';
import 'package:esteshara/features/home/presentation/views/specialist_details_view.dart';
import 'package:esteshara/features/introduction/presentation/views/introduction_view.dart';
import 'package:esteshara/features/profile/presentation/views/profile_view.dart';
import 'package:esteshara/features/reset%20password/presentation/views/reset_password_view.dart';
import 'package:esteshara/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouters {
  static const String kSplashView = '/';
  static const String kIntroductionView = '/introduction';
  static const String kHomeView = '/home';
  static const String kSpecialistDetailsView = 'specialistDetails';
  static const String kNestedSpecialistDetailsView =
      '$kHomeView/$kSpecialistDetailsView';
  static const String kAppointmentsView = '/appointments';
  static const String kProfileView = '/profile';
  static const String kLoginView = '/login';
  static const String kSignupView = '/signup';
  static const String kResetPasswordView = '/resetPassword';

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final routes = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: kSplashView,
    routes: [
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: kIntroductionView,
        builder: (context, state) => const IntroductionView(),
      ),
      GoRoute(
        path: kResetPasswordView,
        builder: (context, state) => const ResetPasswordView(),
      ),
      GoRoute(
        path: kLoginView,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: kSignupView,
        builder: (context, state) => const SignUpView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppNavigator(navigationShell: navigationShell),
        branches: [
          // Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kHomeView,
                builder: (context, state) => const HomeView(),
                routes: [
                  GoRoute(
                    name: kSpecialistDetailsView,
                    path: kSpecialistDetailsView,
                    builder: (context, state) => SpecialistDetailsView(
                      specialist: state.extra as SpecialistModel,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kAppointmentsView,
                builder: (context, state) => const AppointmentsView(),
                routes: [],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kProfileView,
                builder: (context, state) => const ProfileView(),
                routes: [],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
