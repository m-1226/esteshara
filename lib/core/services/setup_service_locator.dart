// Update the setupServiceLocator function in service_locator.dart
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo_impl.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo_impl.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Register FirebaseService as a singleton
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());

  // Register repositories
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(firebaseService: getIt<FirebaseService>()),
  );

  getIt.registerLazySingleton<SpecialistRepo>(
    () => SpecialistRepoImpl(firebaseService: getIt<FirebaseService>()),
  );

  // Register the AppointmentsRepo
  getIt.registerLazySingleton<AppointmentsRepo>(
    () => AppointmentsRepoImpl(firebaseService: getIt<FirebaseService>()),
  );
}
