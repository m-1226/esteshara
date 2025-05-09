// features/home/presentation/views/specialist_details_view.dart
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/appointment_booking_bottom_sheet.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_details_view_body.dart';
import 'package:flutter/material.dart';

class SpecialistDetailsView extends StatelessWidget {
  final SpecialistModel specialist;

  const SpecialistDetailsView({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SpecialistDetailsViewBody(specialist: specialist),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showBookingBottomSheet(context);
          },
          icon: const Icon(Icons.calendar_today),
          label: const Text('Book Appointment'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return AppointmentBookingBottomSheet(
              specialist: specialist,
            );
          },
        );
      },
    );
  }
}
