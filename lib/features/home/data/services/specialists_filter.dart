import 'package:esteshara/features/home/data/models/specialist_model.dart';

class SpecialistsFilter {
  static List<SpecialistModel> filter({
    required List<SpecialistModel> specialists,
    required String? specialization,
    required String searchQuery,
  }) {
    // First filter by specialization if selected
    var filtered = specialization != null
        ? specialists.where((s) => s.specialization == specialization).toList()
        : specialists;

    // Then filter by search query if not empty
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((s) {
        return s.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            s.specialization.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }
}
