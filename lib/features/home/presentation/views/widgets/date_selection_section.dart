import 'package:esteshara/features/home/presentation/views/widgets/date_card.dart';
import 'package:flutter/material.dart';

class DateSelectionSection extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) isDateAvailable;

  const DateSelectionSection({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.isDateAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 14,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isAvailable = isDateAvailable(date);
              final isSelected = DateUtils.isSameDay(date, selectedDate);

              return DateCard(
                date: date,
                isAvailable: isAvailable,
                isSelected: isSelected,
                onTap: isAvailable ? () => onDateSelected(date) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

// features/specialists/presentation/widgets/date_card.dart
