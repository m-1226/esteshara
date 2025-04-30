// features/specialists/presentation/widgets/specialist_card.dart
import 'package:flutter/material.dart';

class SpecialistCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String bio;
  final List<String> availableDays;
  final String? photoUrl;
  final VoidCallback onTap;
  final double price;

  const SpecialistCard({
    super.key,
    required this.name,
    required this.specialization,
    required this.bio,
    required this.availableDays,
    this.photoUrl,
    required this.onTap,
    this.price = 300, // Default price
  });

  @override
  Widget build(BuildContext context) {
    final double rating = 4.5; // Mock rating - would come from your data model

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with avatar and name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Specialist avatar with enhanced styling
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.blue.shade100, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: photoUrl != null && photoUrl!.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(photoUrl!),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  name[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 16),

                      // Name and specialization
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Specialization with pill background
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                specialization,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Favorite icon button
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.grey.shade400,
                        onPressed: () {
                          // Favorite functionality would go here
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rating stars
                  Row(
                    children: [
                      // Star rating
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.floor()
                                ? Icons.star
                                : (index == rating.floor() && rating % 1 > 0)
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        ' (124)',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Bio text with improved typography
                  Text(
                    bio.length > 100 ? '${bio.substring(0, 100)}...' : bio,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Available days section with icon
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Available on:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Available days chips in a horizontal scrollable row
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: availableDays
                          .map((day) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(0.3)),
                                ),
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bottom action row with price and booking button
                  Row(
                    children: [
                      // Price indicator
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Consultation Fee',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              'EGP ${price.toInt()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Book button with enhanced styling
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
