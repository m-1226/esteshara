import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/review_item.dart';
import 'package:flutter/material.dart';

class SpecialistReviewsTab extends StatelessWidget {
  final SpecialistModel specialist;

  const SpecialistReviewsTab({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Summary section with rating and bars
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                // Rating number and stars
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 65, // Fixed width to prevent layout shifts
                      child: Text(
                        '${specialist.rating}',
                        style: AppStyles.regular22.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Star row
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < specialist.rating.floor()
                                    ? Icons.star
                                    : index < specialist.rating
                                        ? Icons.star_half
                                        : Icons.star_border,
                                color: Colors.amber,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Based on ${specialist.reviewCount} reviews',
                            style: AppStyles.regular14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Rating bars with improved layout
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RatingBar(rating: '5', percentage: 0.9),
                    RatingBar(rating: '4', percentage: 0.7),
                    RatingBar(rating: '3', percentage: 0.2),
                    RatingBar(rating: '2', percentage: 0.05),
                    RatingBar(rating: '1', percentage: 0.01),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Reviews list
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ReviewItem(
                name: 'Ahmed Mohamed',
                rating: 5.0,
                comment:
                    'Great doctor! Very knowledgeable and professional. The consultation was very helpful.',
                date: '2 days ago',
              ),
              const ReviewItem(
                name: 'Sara Ahmed',
                rating: 4.5,
                comment:
                    'Very good experience. The doctor was attentive and gave me great advice. Would recommend.',
                date: '1 week ago',
              ),
              const ReviewItem(
                name: 'Mohamed Ali',
                rating: 5.0,
                comment:
                    'Excellent specialist. Very thorough in the examination and clear in explanations.',
                date: '2 weeks ago',
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class RatingBar extends StatelessWidget {
  final String rating;
  final double percentage;

  const RatingBar({
    super.key,
    required this.rating,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40, // Fixed width for consistent spacing
      child: Column(
        children: [
          Text(
            rating,
            style: AppStyles.regular14,
          ),
          const SizedBox(height: 4),
          Container(
            height: 60,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              heightFactor: percentage,
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
