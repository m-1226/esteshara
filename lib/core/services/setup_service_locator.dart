// core/di/service_locator.dart
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo_impl.dart';
import 'package:esteshara/features/specialists/data/repos/spcialists/specialist_repo.dart';
import 'package:esteshara/features/specialists/data/repos/spcialists/specialist_repo_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Register FirebaseService as a singleton
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(firebaseService: getIt<FirebaseService>()),
  );
  getIt.registerLazySingleton<SpecialistRepo>(
    () => SpecialistRepoImpl(firebaseService: getIt<FirebaseService>()),
  );
}
