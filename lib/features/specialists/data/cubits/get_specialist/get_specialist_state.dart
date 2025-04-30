// features/specialists/presentation/cubit/specialists_state.dart
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';

abstract class SpecialistsState {}

class SpecialistsInitial extends SpecialistsState {}

class SpecialistsLoading extends SpecialistsState {}

class SpecialistsLoaded extends SpecialistsState {
  final List<Specialist> specialists;

  SpecialistsLoaded({required this.specialists});
}

class SpecialistsError extends SpecialistsState {
  final String message;

  SpecialistsError({required this.message});
}
