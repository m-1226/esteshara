import 'package:flutter/material.dart';

class SearchToggleButton extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onPressed;

  const SearchToggleButton({
    super.key,
    required this.isSearching,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSearching ? Icons.close : Icons.search,
      ),
      onPressed: onPressed,
    );
  }
}
