import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.size,
    this.color,
  });
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        size: size ?? 70,
        color: color ?? Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
