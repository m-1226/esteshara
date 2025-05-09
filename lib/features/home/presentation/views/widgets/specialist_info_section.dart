import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/price_info.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_avatar.dart';
import 'package:flutter/material.dart';

class SpecialistInfoSection extends StatelessWidget {
  final SpecialistModel specialist;

  const SpecialistInfoSection({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpecialistAvatar(
          photoUrl: specialist.photoUrl,
          name: specialist.name,
          isAvailableToday: true, // This could be a computed property
          width: 50,
          height: 50,
          borderRadius: 25, // Circle
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                specialist.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                specialist.specialization,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        PriceInfo(price: specialist.price),
      ],
    );
  }
}
