import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;
  final String date;

  const ReviewItem({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  name.isNotEmpty ? name[0] : '',
                  style: AppStyles.bold16.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppStyles.bold16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      date,
                      style: AppStyles.regular14,
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating.floor()
                        ? Icons.star
                        : index < rating
                            ? Icons.star_half
                            : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: AppStyles.regular16.copyWith(
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
