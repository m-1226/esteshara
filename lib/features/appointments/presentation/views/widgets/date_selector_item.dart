// features/appointments/presentation/widgets/date_selector_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectorItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const DateSelectorItem({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isAvailable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        width: 65,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.8)
              : isAvailable
                  ? Colors.grey.shade100
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date), // Mon, Tue, etc.
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.black
                        : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d').format(date), // 1, 2, etc.
              style: TextStyle(
                fontSize: 20,
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.black
                        : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM').format(date), // Jan, Feb, etc.
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.black
                        : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime date) onDateSelected;
  final bool Function(DateTime date) isAvailableDay;
  final int daysToShow;
  final int startFromDays;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.isAvailableDay,
    this.daysToShow = 14,
    this.startFromDays = 1, // Start from tomorrow by default
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysToShow,
        itemBuilder: (context, index) {
          final date =
              DateTime.now().add(Duration(days: index + startFromDays));
          final isAvailable = isAvailableDay(date);
          final isSelected = DateUtils.isSameDay(date, selectedDate);

          return DateSelectorItem(
            date: date,
            isSelected: isSelected,
            isAvailable: isAvailable,
            onTap: isAvailable ? () => onDateSelected(date) : null,
          );
        },
      ),
    );
  }
}
