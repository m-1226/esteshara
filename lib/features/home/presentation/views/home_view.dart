// features/home/presentation/views/home_view.dart
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? selectedSpecialization;
  String searchQuery = '';
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load all specialists when the view is initialized
    context.read<GetSpecialistsCubit>().getAllSpecialists();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSpecialization(String specialization) {
    setState(() {
      if (selectedSpecialization == specialization) {
        selectedSpecialization = null;
      } else {
        selectedSpecialization = specialization;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
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
                    : const Text(
                        'Available Specialists',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.black87),
                    onPressed: () {
                      // Handle notifications
                    },
                  ),
                ],
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildCategorySelector(),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        'Top Specialists',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
            builder: (context, state) {
              if (state is SpecialistsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SpecialistsError) {
                return Center(child: Text(state.message));
              } else if (state is SpecialistsLoaded) {
                final filteredSpecialists =
                    _filterSpecialists(state.specialists);

                if (filteredSpecialists.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: filteredSpecialists.length,
                  itemBuilder: (context, index) {
                    final specialist = filteredSpecialists[index];
                    return SpecialistCard(
                      specialist: specialist,
                      onTap: () {
                        // Navigate to specialist detail
                        context.pushNamed(
                          AppRouters.kSpecialistDetailsView,
                          extra: specialist,
                        );
                      },
                    );
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Scroll to top when FAB is pressed
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
      builder: (context, state) {
        if (state is! SpecialistsLoaded) {
          return const SizedBox(height: 100);
        }

        // Extract unique specializations
        final specializations = _getUniqueSpecializations(state.specialists);

        // Map specializations to icons
        final Map<String, IconData> specializationIcons = {
          'Cardiologist': Icons.favorite,
          'Dermatologist': Icons.face,
          'Pediatrician': Icons.child_care,
          'Business Consultant': Icons.business,
          'Career Coach': Icons.work,
          'Neurologist': Icons.psychology,
          'Psychiatrist': Icons.sentiment_satisfied_alt,
        };

        return Container(
          height: 100,
          margin: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: specializations.length + 1, // +1 for "All" category
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" category
                return _buildCategoryItem(
                  icon: Icons.apps,
                  label: 'All',
                  isSelected: selectedSpecialization == null,
                  onTap: () => setState(() {
                    selectedSpecialization = null;
                  }),
                );
              }

              final specialization = specializations[index - 1];
              return _buildCategoryItem(
                icon: specializationIcons[specialization] ??
                    Icons.medical_services,
                label: specialization.replaceAll('ist', ''), // Shorter labels
                isSelected: selectedSpecialization == specialization,
                onTap: () => _toggleSpecialization(specialization),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = _getSpecializationColor(label);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No specialists found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different search terms or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selectedSpecialization = null;
                searchQuery = '';
                _searchController.clear();
                isSearching = false;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
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
        return s.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            s.specialization.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  // Helper method to get color for specialization
  Color _getSpecializationColor(String specialization) {
    final Map<String, Color> specializationColors = {
      'All': Colors.blue.shade600,
      'Cardiologist': Colors.red.shade400,
      'Cardio': Colors.red.shade400,
      'Dermatologist': Colors.purple.shade400,
      'Dermato': Colors.purple.shade400,
      'Pediatrician': Colors.green.shade400,
      'Pediatr': Colors.green.shade400,
      'Business Consultant': Colors.blue.shade400,
      'Business': Colors.blue.shade400,
      'Career Coach': Colors.orange.shade400,
      'Career': Colors.orange.shade400,
      'Neurologist': Colors.indigo.shade400,
      'Neuro': Colors.indigo.shade400,
      'Psychiatrist': Colors.pink.shade400,
      'Psych': Colors.pink.shade400,
    };

    return specializationColors[specialization] ??
        Theme.of(context).primaryColor;
  }
}

class SpecialistCard extends StatelessWidget {
  final SpecialistModel specialist;
  final VoidCallback onTap;

  const SpecialistCard({
    super.key,
    required this.specialist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isAvailableToday = _isAvailableToday(specialist);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor avatar with availability indicator
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: specialist.photoUrl.isNotEmpty
                        ? Image.network(
                            specialist.photoUrl,
                            width: 80,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 100,
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Text(
                                    specialist.name.isNotEmpty
                                        ? specialist.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 80,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Text(
                                specialist.name.isNotEmpty
                                    ? specialist.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                  ),
                  if (isAvailableToday)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialist.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            _getSpecializationColor(specialist.specialization)
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        specialist.specialization,
                        style: TextStyle(
                          color: _getSpecializationColor(
                              specialist.specialization),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < specialist.rating.floor()
                                  ? Icons.star
                                  : index < specialist.rating
                                      ? Icons.star_half
                                      : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${specialist.reviewCount})',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: isAvailableToday
                              ? Colors.green
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAvailableToday
                              ? 'Available today'
                              : 'Not available today',
                          style: TextStyle(
                            color: isAvailableToday
                                ? Colors.green
                                : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${specialist.price.toStringAsFixed(0)} EGP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildExperienceChip(context, '5+ yrs'),
                        const SizedBox(width: 8),
                        _buildExperienceChip(context, '98% success'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  bool _isAvailableToday(SpecialistModel specialist) {
    final today = DateTime.now();
    final dayName = _getDayName(today.weekday);
    return specialist.availableTimes.any((time) => time.day == dayName);
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  Color _getSpecializationColor(String specialization) {
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
