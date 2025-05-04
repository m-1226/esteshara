// core/utils/app_routers.dart
import 'package:esteshara/features/app%20navigator/presentation/views/app_navigator.dart';
import 'package:esteshara/features/appointments/presentation/views/appointments_view.dart';
import 'package:esteshara/features/auth/presentation/views/login/login_view.dart';
import 'package:esteshara/features/auth/presentation/views/signup/signup_view.dart';
import 'package:esteshara/features/specialists/presentation/views/specialists_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouters {
  static const String kSplashView = '/';
  static const String kSpecialistsView = '/specialists';
  static const String kAppointmentsView = '/appointments';
  static const String kUserDetailsView = 'specialistDetails';
  static const String kLoginView = '/login';
  static const String kSignupView = '/signup';

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final routes = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: kLoginView,
    routes: [
      // GoRoute(
      //   path: kSplashView,
      //   builder: (context, state) => const SplashView(),
      // ),
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
                path: kSpecialistsView,
                builder: (context, state) => const SpecialistsView(),
                routes: [],
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
        ],
      ),
    ],
  );
}
