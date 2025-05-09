import 'package:flutter/material.dart';

class SpecialistBackgroundImage extends StatelessWidget {
  final String photoUrl;

  const SpecialistBackgroundImage({
    super.key,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Opacity(
        opacity: 0.3,
        child: Image.network(
          photoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => Container(),
        ),
      ),
    );
  }
}
