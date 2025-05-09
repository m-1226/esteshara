import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

// Avatar widget
class SpecialistDetailsAvatar extends StatelessWidget {
  final String name;
  final String photoUrl;

  const SpecialistDetailsAvatar({
    super.key,
    required this.name,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
      child: photoUrl.isEmpty
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '',
              style: AppStyles.bold18.copyWith(
                fontSize: 30,
              ),
            )
          : null,
    );
  }
}
