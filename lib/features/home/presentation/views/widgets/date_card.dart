import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCard extends StatelessWidget {
  final DateTime date;
  final bool isAvailable;
  final bool isSelected;
  final VoidCallback? onTap;

  const DateCard({
    super.key,
    required this.date,
    required this.isAvailable,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(date, now);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.9)
              : isAvailable
                  ? Colors.white
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected || isAvailable
              ? [
                  BoxShadow(
                    color: isSelected
                        ? theme.primaryColor.withOpacity(0.4)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : isAvailable
                    ? Colors.grey.shade300
                    : Colors.grey.shade200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.black
                        : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d').format(date),
              style: TextStyle(
                fontSize: 22,
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? Colors.black
                        : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isToday
                    ? isSelected
                        ? Colors.white.withOpacity(0.3)
                        : theme.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isToday ? 'Today' : DateFormat('MMM').format(date),
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? theme.primaryColor
                          : isAvailable
                              ? Colors.black
                              : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
