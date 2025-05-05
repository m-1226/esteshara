// features/specialists/data/repos/specialist_repo_impl.dart
// Add this method to your existing SpecialistRepoImpl class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esteshara/core/services/firebase_service.dart';

Future<void> addSpecialistsData() async {
  try {
    final FirebaseService firebaseService = FirebaseService();
    // First check if specialists collection already has data
    final QuerySnapshot snapshot = await firebaseService.firestore
        .collection('specialists')
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      print('Specialists data already exists, skipping seed');
      return;
    }

    // Create batch to add all specialists at once for better performance
    final WriteBatch batch = firebaseService.firestore.batch();

    // List of 10 specialists
    final specialists = [
      {
        'name': 'Dr. Ahmed Hassan',
        'specialization': 'Cardiologist',
        'bio':
            'Experienced cardiologist with 10+ years of practice in treating heart conditions and cardiovascular diseases. Board certified with expertise in preventive care.',
        'photoUrl':
            'https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg',
        'availableTimes': [
          {'day': 'Monday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Wednesday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Friday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
        ],
        'price': 350.0,
        'rating': 4.7,
        'reviewCount': 124,
      },
      {
        'name': 'Dr. Sara Mahmoud',
        'specialization': 'Dermatologist',
        'bio':
            'Specialist in skin conditions and cosmetic dermatology with a focus on holistic treatment approaches. Expert in treating various skin conditions and rejuvenation techniques.',
        'photoUrl':
            'https://img.freepik.com/free-photo/young-beautiful-successful-female-doctor-with-stethoscope-portrait_186202-1506.jpg',
        'availableTimes': [
          {'day': 'Tuesday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Thursday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Saturday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
        ],
        'price': 400.0,
        'rating': 4.9,
        'reviewCount': 89,
      },
      {
        'name': 'Dr. Laila Farid',
        'specialization': 'Pediatrician',
        'bio':
            'Caring pediatrician dedicated to the health and wellbeing of children from infancy through adolescence. Specializes in developmental pediatrics and childhood nutrition.',
        'photoUrl':
            'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827776.jpg',
        'availableTimes': [
          {'day': 'Sunday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Wednesday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Thursday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
        ],
        'price': 250.0,
        'rating': 4.8,
        'reviewCount': 142,
      },
      {
        'name': 'Dr. Omar Nabil',
        'specialization': 'Career Coach',
        'bio':
            'Professional career advisor with expertise in helping professionals navigate career transitions and growth. Former HR director with 15 years of experience.',
        'photoUrl':
            'https://img.freepik.com/free-photo/young-handsome-physician-medical-robe-with-stethoscope_1303-17818.jpg',
        'availableTimes': [
          {'day': 'Monday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Friday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Sunday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
        ],
        'price': 250.0,
        'rating': 4.4,
        'reviewCount': 78,
      },
      {
        'name': 'Dr. Youssef Malek',
        'specialization': 'Neurologist',
        'bio':
            'Experienced neurologist specializing in the diagnosis and treatment of disorders of the nervous system, including the brain, spinal cord, and peripheral nerves.',
        'photoUrl':
            'https://img.freepik.com/free-photo/portrait-smiling-male-doctor_171337-1532.jpg',
        'availableTimes': [
          {'day': 'Monday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Thursday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
          {'day': 'Sunday', 'startTime': '09:00 AM', 'endTime': '05:00 PM'},
        ],
        'price': 380.0,
        'rating': 4.7,
        'reviewCount': 95,
      },
      {
        'name': 'Dr. Amira Fouad',
        'specialization': 'Psychiatrist',
        'bio':
            'Compassionate psychiatrist with a focus on mental health and wellbeing. Specializes in anxiety disorders, depression, and stress management.',
        'photoUrl':
            'https://img.freepik.com/free-photo/smiling-young-female-doctor-holding-medical-clipboard_171337-8665.jpg',
        'availableTimes': [
          {'day': 'Tuesday', 'startTime': '10:00 AM', 'endTime': '06:00 PM'},
          {'day': 'Thursday', 'startTime': '10:00 AM', 'endTime': '06:00 PM'},
          {'day': 'Saturday', 'startTime': '10:00 AM', 'endTime': '04:00 PM'},
        ],
        'price': 450.0,
        'rating': 4.9,
        'reviewCount': 112,
      },
      {
        'name': 'Dr. Tamer Hossam',
        'specialization': 'Orthopedic Surgeon',
        'bio':
            'Skilled orthopedic surgeon specializing in sports injuries, joint replacements, and minimally invasive procedures. Dedicated to restoring mobility and improving quality of life.',
        'photoUrl':
            'https://img.freepik.com/free-photo/doctor-with-stethoscope-hands-hospital-background_1423-1.jpg',
        'availableTimes': [
          {'day': 'Monday', 'startTime': '08:00 AM', 'endTime': '04:00 PM'},
          {'day': 'Wednesday', 'startTime': '08:00 AM', 'endTime': '04:00 PM'},
          {'day': 'Friday', 'startTime': '08:00 AM', 'endTime': '04:00 PM'},
        ],
        'price': 500.0,
        'rating': 4.6,
        'reviewCount': 86,
      },
      {
        'name': 'Dr. Heba Salah',
        'specialization': 'Nutritionist',
        'bio':
            'Clinical nutritionist with expertise in dietary planning, weight management, and nutritional therapy. Helps clients achieve optimal health through personalized nutrition plans.',
        'photoUrl':
            'https://img.freepik.com/free-photo/portrait-smiling-young-woman-doctor-medicine-with-stethoscope_1301-7807.jpg',
        'availableTimes': [
          {'day': 'Sunday', 'startTime': '10:00 AM', 'endTime': '06:00 PM'},
          {'day': 'Tuesday', 'startTime': '10:00 AM', 'endTime': '06:00 PM'},
          {'day': 'Thursday', 'startTime': '10:00 AM', 'endTime': '06:00 PM'},
        ],
        'price': 280.0,
        'rating': 4.8,
        'reviewCount': 134,
      },
    ];

    // Add each specialist to the batch
    for (var specialist in specialists) {
      final DocumentReference docRef =
          firebaseService.firestore.collection('specialists').doc();
      batch.set(docRef, specialist);
    }

    // Commit the batch
    await batch.commit();

    print('Successfully added 10 specialists to the database');
  } catch (e) {
    print('Error adding specialists data: $e');
    rethrow;
  }
}
