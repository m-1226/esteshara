// features/home/presentation/widgets/home_app_bar.dart
import 'package:esteshara/features/home/presentation/views/widgets/appbar_title.dart';
import 'package:esteshara/features/home/presentation/views/widgets/notification_icon.dart';
import 'package:esteshara/features/home/presentation/views/widgets/search_field.dart';
import 'package:esteshara/features/home/presentation/views/widgets/search_toggle_button.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchToggled;

  const HomeAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: isSearching
          ? SearchField(
              controller: searchController,
              onChanged: onSearchChanged,
            )
          : const AppBarTitle(),
      actions: [
        SearchToggleButton(
          isSearching: isSearching,
          onPressed: onSearchToggled,
        ),
        const NotificationButton(),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
    );
  }
}
