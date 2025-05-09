// features/home/presentation/widgets/scroll_to_top_button.dart
import 'package:flutter/material.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double showThreshold;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.showThreshold =
        300.0, // Button appears after scrolling this many pixels
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final shouldShowButton =
        widget.scrollController.position.pixels >= widget.showThreshold;

    if (shouldShowButton != _showButton) {
      setState(() {
        _showButton = shouldShowButton;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _showButton ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: _showButton
          ? FloatingActionButton(
              onPressed: () {
                // Scroll to top when FAB is pressed
                widget.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.arrow_upward),
            )
          : const SizedBox
              .shrink(), // Invisible placeholder when button is hidden
    );
  }
}
