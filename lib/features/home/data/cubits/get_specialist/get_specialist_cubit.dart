// features/specialists/presentation/cubit/specialists_cubit.dart
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/home/data/repos/spcialists/specialist_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSpecialistsCubit extends Cubit<GetSpecialistsState> {
  final SpecialistRepo specialistRepo;

  GetSpecialistsCubit({required this.specialistRepo})
      : super(SpecialistsInitial());

  Future<void> getAllSpecialists() async {
    emit(SpecialistsLoading());
    try {
      final specialists = await specialistRepo.getAllSpecialists();
      emit(SpecialistsLoaded(specialists: specialists));
    } catch (e) {
      emit(SpecialistsError(message: 'Failed to load specialists'));
    }
  }

  Future<void> getSpecialistsBySpecialization(String specialization) async {
    emit(SpecialistsLoading());
    try {
      final specialists =
          await specialistRepo.getSpecialistsBySpecialization(specialization);
      emit(SpecialistsLoaded(specialists: specialists));
    } catch (e) {
      emit(SpecialistsError(message: 'Failed to load specialists'));
    }
  }
}
