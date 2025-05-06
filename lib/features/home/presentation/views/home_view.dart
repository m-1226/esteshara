// features/home/presentation/views/home_view.dart
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:esteshara/features/home/data/services/specialists_filter.dart';
import 'package:esteshara/features/home/presentation/views/category_selector.dart';
import 'package:esteshara/features/home/presentation/views/widgets/empty_specialists_state.dart';
import 'package:esteshara/features/home/presentation/views/widgets/error_display.dart';
import 'package:esteshara/features/home/presentation/views/widgets/home_app_bar.dart';
import 'package:esteshara/features/home/presentation/views/widgets/loading_indicator.dart';
import 'package:esteshara/features/home/presentation/views/widgets/scroll_top_button.dart';
import 'package:esteshara/features/home/presentation/views/widgets/section_header.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialists_list.dart';
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
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load all specialists when the view is initialized
    context.read<GetSpecialistsCubit>().getAllSpecialists();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              HomeAppBar(
                isSearching: isSearching,
                searchController: searchController,
                onSearchChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
                onSearchToggled: () {
                  setState(() {
                    if (isSearching) {
                      searchController.clear();
                      searchQuery = '';
                    }
                    isSearching = !isSearching;
                  });
                },
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Categories'),
                    CategorySelector(
                      onCategorySelected: (category) {
                        setState(() {
                          selectedSpecialization = category;
                        });
                      },
                      selectedCategory: selectedSpecialization,
                    ),
                    const SectionHeader(title: 'Top Specialists'),
                  ],
                ),
              ),
            ];
          },
          body: BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
            builder: (context, state) {
              if (state is SpecialistsLoading) {
                return const LoadingIndicator();
              } else if (state is SpecialistsError) {
                return ErrorDisplay(message: state.message);
              } else if (state is SpecialistsLoaded) {
                final filteredSpecialists = SpecialistsFilter.filter(
                  specialists: state.specialists,
                  specialization: selectedSpecialization,
                  searchQuery: searchQuery,
                );

                if (filteredSpecialists.isEmpty) {
                  return EmptySpecialistsState(
                    onClearFilters: () {
                      setState(() {
                        selectedSpecialization = null;
                        searchQuery = '';
                        searchController.clear();
                        isSearching = false;
                      });
                    },
                  );
                }

                return SpecialistsList(
                  specialists: filteredSpecialists,
                  onSpecialistTap: (specialist) {
                    context.pushNamed(
                      AppRouters.kSpecialistDetailsView,
                      extra: specialist,
                    );
                  },
                );
              }

              return const LoadingIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: ScrollToTopButton(
        scrollController: scrollController,
      ),
    );
  }
}
