import 'package:flutter/material.dart';

class SpecialistAvatar extends StatelessWidget {
  final String photoUrl;
  final String name;
  final bool isAvailableToday;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? indicatorSize;

  const SpecialistAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.isAvailableToday,
    this.width = 80,
    this.height = 100,
    this.borderRadius = 12,
    this.indicatorSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          child: photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildAvatarFallback();
                  },
                )
              : _buildAvatarFallback(),
        ),
        if (isAvailableToday)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
