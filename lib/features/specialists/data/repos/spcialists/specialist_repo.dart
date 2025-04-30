// features/specialists/data/repos/specialist_repo.dart
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';

abstract class SpecialistRepo {
  Future<List<Specialist>> getAllSpecialists();
  Future<List<Specialist>> getSpecialistsBySpecialization(
      String specialization);
  Future<Specialist?> getSpecialistById(String id);
}
