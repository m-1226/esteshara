// features/specialists/data/repos/specialist_repo.dart
import 'package:esteshara/features/home/data/models/specialist_model.dart';

abstract class SpecialistRepo {
  Future<List<SpecialistModel>> getAllSpecialists();
  Future<List<SpecialistModel>> getSpecialistsBySpecialization(
      String specialization);
  Future<SpecialistModel?> getSpecialistById(String id);
}
