// features/specialists/presentation/widgets/specialist_card.dart
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
import 'package:flutter/material.dart';

import 'appointment_booking_bottom_sheet.dart';

class SpecialistCard extends StatelessWidget {
  final SpecialistModel specialist;
  final VoidCallback onTap;

  const SpecialistCard({
    super.key,
    required this.specialist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get color based on specialization
    final Color specialistColor =
        _getSpecializationColor(specialist.specialization);
    final Color lightColor = specialistColor.withOpacity(0.1);
    final Color borderColor = specialistColor.withOpacity(0.3);

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
                          color: lightColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: specialist.photoUrl.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(specialist.photoUrl),
                              )
                            : CircleAvatar(
                                backgroundColor: lightColor,
                                child: Text(
                                  specialist.name[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: specialistColor,
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
                              specialist.name,
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
                                color: lightColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                specialist.specialization,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: specialistColor,
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
                            index < specialist.rating.floor()
                                ? Icons.star
                                : (index == specialist.rating.floor() &&
                                        specialist.rating % 1 > 0)
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        specialist.rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        ' (${specialist.reviewCount})',
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
                    specialist.bio.length > 100
                        ? '${specialist.bio.substring(0, 100)}...'
                        : specialist.bio,
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
                      children: specialist.availableTimes
                          .map((time) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: lightColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  time.day,
                                  style: TextStyle(
                                    color: specialistColor,
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
                              'EGP ${specialist.price.toInt()}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: specialistColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Book button with enhanced styling
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showBookingBottomSheet(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: specialistColor,
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

  // Helper method to get color for specialization
  Color _getSpecializationColor(String specialization) {
    final Map<String, Color> specializationColors = {
      'Cardiologist': Colors.red.shade400,
      'Dermatologist': Colors.purple.shade400,
      'Pediatrician': Colors.green.shade400,
      'Business Consultant': Colors.blue.shade400,
      'Career Coach': Colors.orange.shade400,
      'Neurologist': Colors.indigo.shade400,
      'Psychiatrist': Colors.pink.shade400,
    };

    return specializationColors[specialization] ?? Colors.blue.shade600;
  }

  // Show booking bottom sheet
  void _showBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return AppointmentBookingBottomSheet(specialist: specialist);
          },
        );
      },
    );
  }
}
