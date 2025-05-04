// features/appointments/presentation/widgets/specialist_info_widget.dart
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
import 'package:flutter/material.dart';

class SpecialistInfoWidget extends StatelessWidget {
  final SpecialistModel specialist;
  final double avatarRadius;
  final double nameSize;
  final double specializationSize;

  const SpecialistInfoWidget({
    super.key,
    required this.specialist,
    this.avatarRadius = 25,
    this.nameSize = 16,
    this.specializationSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundImage: specialist.photoUrl.isNotEmpty
              ? NetworkImage(specialist.photoUrl)
              : null,
          child: specialist.photoUrl.isEmpty
              ? Text(specialist.name.isNotEmpty
                  ? specialist.name[0].toUpperCase()
                  : 'U')
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                specialist.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: nameSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                specialist.specialization,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: specializationSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialistLoading extends StatelessWidget {
  final double avatarRadius;

  const SpecialistLoading({
    super.key,
    this.avatarRadius = 25,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            Icons.person,
            size: avatarRadius * 1.5,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 18,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 14,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
