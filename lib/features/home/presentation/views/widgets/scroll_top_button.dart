// features/home/presentation/widgets/scroll_to_top_button.dart
import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Scroll to top when FAB is pressed
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.arrow_upward),
    );
  }
}
