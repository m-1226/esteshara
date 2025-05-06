import 'package:flutter/material.dart';

class SpecialistAvatar extends StatelessWidget {
  final String photoUrl;
  final String name;
  final bool isAvailableToday;

  const SpecialistAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.isAvailableToday,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  width: 80,
                  height: 100,
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
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: 80,
      height: 100,
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
