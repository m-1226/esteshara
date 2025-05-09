import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class WorkingHourItem extends StatelessWidget {
  final String day;
  final bool isAvailable;
  final String? startTime;
  final String? endTime;

  const WorkingHourItem({
    super.key,
    required this.day,
    required this.isAvailable,
    this.startTime,
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.grey.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAvailable ? Colors.grey.shade200 : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              day,
              style: isAvailable
                  ? AppStyles.regular16
                  : AppStyles.regular14.copyWith(color: Colors.grey.shade600),
            ),
          ),
          Text(
            isAvailable ? '$startTime - $endTime' : 'Unavailable',
            style: isAvailable
                ? AppStyles.bold16.copyWith(
                    color: Theme.of(context).primaryColor,
                  )
                : AppStyles.regular14.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
