// features/specialists/presentation/views/widgets/specialists_view_body.dart
import 'package:esteshara/features/specialists/data/models/specialist_model.dart';
import 'package:esteshara/features/specialists/presentation/views/widgets/specialist_card.dart';
import 'package:flutter/material.dart';

class SpecialistsViewBody extends StatelessWidget {
  const SpecialistsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Create mock specialists using our model
    final List<SpecialistModel> specialists = _getMockSpecialists();

    return ListView.builder(
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        final specialist = specialists[index];
        return SpecialistCard(
          specialist: specialist,
          onTap: () {
            // For now, just show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected: ${specialist.name}')),
            );
          },
        );
      },
    );
  }

  // Helper method to create mock specialist data
  List<SpecialistModel> _getMockSpecialists() {
    return [
      SpecialistModel(
        id: '1',
        name: 'Dr. Ahmed Hassan',
        specialization: 'Cardiologist',
        bio:
            'Experienced cardiologist with 10+ years of practice in treating heart conditions and cardiovascular diseases. Board certified with expertise in preventive care.',
        photoUrl:
            'https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg',
        availableTimes:
            _createAvailabilityTimes(['Monday', 'Wednesday', 'Friday']),
        price: 350,
        rating: 4.7,
        reviewCount: 124,
      ),
      SpecialistModel(
        id: '2',
        name: 'Dr. Sara Mahmoud',
        specialization: 'Dermatologist',
        bio:
            'Specialist in skin conditions and cosmetic dermatology with a focus on holistic treatment approaches. Expert in treating various skin conditions and rejuvenation techniques.',
        photoUrl:
            'https://img.freepik.com/free-photo/young-beautiful-successful-female-doctor-with-stethoscope-portrait_186202-1506.jpg',
        availableTimes:
            _createAvailabilityTimes(['Tuesday', 'Thursday', 'Saturday']),
        price: 400,
        rating: 4.9,
        reviewCount: 89,
      ),
      SpecialistModel(
        id: '3',
        name: 'Dr. Khaled Omar',
        specialization: 'Business Consultant',
        bio:
            'Strategic business advisor helping companies optimize their operations and increase profitability. Specialized in startups and growth-stage businesses.',
        photoUrl:
            'https://img.freepik.com/free-photo/confident-business-consultant-portrait_23-2147639158.jpg',
        availableTimes:
            _createAvailabilityTimes(['Monday', 'Tuesday', 'Wednesday']),
        price: 500,
        rating: 4.5,
        reviewCount: 56,
      ),
      SpecialistModel(
        id: '4',
        name: 'Dr. Laila Farid',
        specialization: 'Pediatrician',
        bio:
            'Caring pediatrician dedicated to the health and wellbeing of children from infancy through adolescence. Specializes in developmental pediatrics and childhood nutrition.',
        photoUrl:
            'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827776.jpg',
        availableTimes:
            _createAvailabilityTimes(['Sunday', 'Wednesday', 'Thursday']),
        price: 300,
        rating: 4.8,
        reviewCount: 142,
      ),
      SpecialistModel(
        id: '5',
        name: 'Dr. Omar Nabil',
        specialization: 'Career Coach',
        bio:
            'Professional career advisor with expertise in helping professionals navigate career transitions and growth. Former HR director with 15 years of experience.',
        photoUrl:
            'https://img.freepik.com/free-photo/young-handsome-physician-medical-robe-with-stethoscope_1303-17818.jpg',
        availableTimes:
            _createAvailabilityTimes(['Monday', 'Friday', 'Sunday']),
        price: 250,
        rating: 4.4,
        reviewCount: 78,
      ),
      SpecialistModel(
        id: '6',
        name: 'Dr. Nadia Ibrahim',
        specialization: 'Financial Advisor',
        bio:
            'Certified financial planner with expertise in investment strategies, retirement planning, and wealth management for individuals and families.',
        photoUrl:
            'https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg',
        availableTimes:
            _createAvailabilityTimes(['Tuesday', 'Wednesday', 'Saturday']),
        price: 450,
        rating: 4.6,
        reviewCount: 63,
      ),
      SpecialistModel(
        id: '7',
        name: 'Dr. Youssef Malek',
        specialization: 'Neurologist',
        bio:
            'Experienced neurologist specializing in the diagnosis and treatment of disorders of the nervous system, including the brain, spinal cord, and peripheral nerves.',
        photoUrl:
            'https://img.freepik.com/free-photo/portrait-smiling-male-doctor_171337-1532.jpg',
        availableTimes:
            _createAvailabilityTimes(['Monday', 'Thursday', 'Sunday']),
        price: 380,
        rating: 4.7,
        reviewCount: 95,
      ),
    ];
  }

  // Helper method to create availability times
  List<AvailabilityTime> _createAvailabilityTimes(List<String> days) {
    return days
        .map((day) => AvailabilityTime(
              day: day,
              startTime: '09:00 AM',
              endTime: '05:00 PM',
            ))
        .toList();
  }
}
