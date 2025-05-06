import 'package:flutter/material.dart';

class AvailabilityAndPriceRow extends StatelessWidget {
  final bool isAvailableToday;
  final double price;

  const AvailabilityAndPriceRow({
    super.key,
    required this.isAvailableToday,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: isAvailableToday ? Colors.green : Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Text(
          isAvailableToday ? 'Available today' : 'Not available today',
          style: TextStyle(
            color: isAvailableToday ? Colors.green : Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          '${price.toStringAsFixed(0)} EGP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
