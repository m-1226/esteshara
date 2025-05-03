// features/specialists/presentation/views/specialists_view.dart
import 'package:esteshara/features/specialists/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/specialists/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
import 'package:esteshara/features/specialists/presentation/views/widgets/specialists_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialistsView extends StatefulWidget {
  const SpecialistsView({super.key});

  @override
  State<SpecialistsView> createState() => _SpecialistsViewState();
}

class _SpecialistsViewState extends State<SpecialistsView> {
  String? selectedSpecialization;
  String searchQuery = '';
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load all specialists when the view is initialized
    context.read<GetSpecialistsCubit>().getAllSpecialists();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search specialists...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                autofocus: true,
              )
            : const Text('Available Specialists'),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  _searchController.clear();
                  searchQuery = '';
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Specialization filter section
          _buildSpecializationFilter(),

          // Specialists list
          Expanded(
            child: BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
              builder: (context, state) {
                if (state is SpecialistsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SpecialistsError) {
                  return Center(child: Text(state.message));
                } else if (state is SpecialistsLoaded) {
                  // Filter specialists based on specialization and search query
                  final filteredSpecialists =
                      _filterSpecialists(state.specialists);

                  if (filteredSpecialists.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No specialists found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (selectedSpecialization != null ||
                              searchQuery.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedSpecialization = null;
                                  searchQuery = '';
                                  _searchController.clear();
                                  isSearching = false;
                                });
                              },
                              child: const Text('Clear filters'),
                            ),
                        ],
                      ),
                    );
                  }

                  return SpecialistsViewBody(specialists: filteredSpecialists);
                }

                // Default state (initial)
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationFilter() {
    return BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
      builder: (context, state) {
        if (state is! SpecialistsLoaded) {
          return const SizedBox.shrink();
        }

        // Extract unique specializations
        final specializations = _getUniqueSpecializations(state.specialists);

        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // "All" filter option
              _buildSpecializationChip(
                label: 'All',
                isSelected: selectedSpecialization == null,
                onSelected: () {
                  setState(() {
                    selectedSpecialization = null;
                  });
                },
              ),
              ...specializations.map((spec) => _buildSpecializationChip(
                    label: spec,
                    isSelected: selectedSpecialization == spec,
                    onSelected: () {
                      setState(() {
                        selectedSpecialization =
                            selectedSpecialization == spec ? null : spec;
                      });
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecializationChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    final color = _getSpecializationColor(label);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        backgroundColor: color.withOpacity(0.1),
        selectedColor: color,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: color.withOpacity(0.5),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  // Helper methods
  List<String> _getUniqueSpecializations(List<SpecialistModel> specialists) {
    final Set<String> uniqueSpecializations = {};
    for (var specialist in specialists) {
      uniqueSpecializations.add(specialist.specialization);
    }
    return uniqueSpecializations.toList()..sort();
  }

  List<SpecialistModel> _filterSpecialists(List<SpecialistModel> specialists) {
    // First filter by specialization if selected
    var filtered = selectedSpecialization != null
        ? specialists
            .where((s) => s.specialization == selectedSpecialization)
            .toList()
        : specialists;

    // Then filter by search query if not empty
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((s) {
        return s.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  // Helper method to get color for specialization (same as in SpecialistCard)
  Color _getSpecializationColor(String specialization) {
    if (specialization == 'All') return Colors.blue.shade600;

    final Map<String, Color> specializationColors = {
      'Cardiologist': Colors.red.shade400,
      'Dermatologist': Colors.purple.shade400,
      'Pediatrician': Colors.green.shade400,
      'Business Consultant': Colors.blue.shade400,
      'Career Coach': Colors.orange.shade400,
      'Neurologist': Colors.indigo.shade400,
      'Psychiatrist': Colors.pink.shade400,
    };

    return specializationColors[specialization] ?? Colors.blue.shade600;
  }
}
