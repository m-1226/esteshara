// features/specialists/presentation/cubit/specialists_state.dart
import 'package:esteshara/features/home/data/models/specialist_model.dart';

abstract class GetSpecialistsState {}

class SpecialistsInitial extends GetSpecialistsState {}

class SpecialistsLoading extends GetSpecialistsState {}

class SpecialistsLoaded extends GetSpecialistsState {
  final List<SpecialistModel> specialists;

  SpecialistsLoaded({required this.specialists});
}

class SpecialistsError extends GetSpecialistsState {
  final String message;

  SpecialistsError({required this.message});
}
