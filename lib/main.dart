import 'package:esteshara/core/cubits/theme/theme_cubit.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_constants.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/core/utils/app_themes.dart';
import 'package:esteshara/features/appointments/data/cubits/appointments_cubit.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo.dart';
import 'package:esteshara/firebase_options.dart';
import 'package:esteshara/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.kHiveBox);
  setupServiceLocator();
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => GetSpecialistsCubit(
            specialistRepo: getIt<SpecialistRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => AppointmentsCubit(
            appointmentsRepo: getIt<AppointmentsRepo>(),
          ),
        ),
      ],
      child: const Esteshara(),
    ),
  );
  // addSpecialistsData();
}

class Esteshara extends StatelessWidget {
  const Esteshara({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            routerConfig: AppRouters.routes,
            debugShowCheckedModeBanner: false,
            locale: const Locale('en', 'US'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US')],
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: state.themeMode,
          ),
        );
      },
    );
  }
}
