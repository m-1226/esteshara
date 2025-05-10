// features/specialists/presentation/widgets/appointment_booking_bottom_sheet.dart
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/features/appointments/data/repos/appointments/appointments_repo.dart';
import 'package:esteshara/features/home/data/manager/booking_manager.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/booking_confirmation_button.dart';
import 'package:esteshara/features/home/presentation/views/widgets/booking_header.dart';
import 'package:esteshara/features/home/presentation/views/widgets/date_selection_section.dart';
import 'package:esteshara/features/home/presentation/views/widgets/exisiting_appointment_warning.dart';
import 'package:esteshara/features/home/presentation/views/widgets/loading_view.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_info_section.dart';
import 'package:esteshara/features/home/presentation/views/widgets/time_selection_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppointmentBookingBottomSheet extends StatefulWidget {
  final SpecialistModel specialist;

  const AppointmentBookingBottomSheet({
    super.key,
    required this.specialist,
  });

  @override
  State<AppointmentBookingBottomSheet> createState() =>
      _AppointmentBookingBottomSheetState();
}

class _AppointmentBookingBottomSheetState
    extends State<AppointmentBookingBottomSheet> {
  // Manager for all business logic
  late final BookingManager _bookingManager;

  @override
  void initState() {
    super.initState();
    _bookingManager = BookingManager(
      specialist: widget.specialist,
      appointmentsRepo: getIt<AppointmentsRepo>(),
      onStateChanged: () => setState(() {}),
    );
    _bookingManager.initialize();
  }

  @override
  void dispose() {
    _bookingManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching data
    if (_bookingManager.isLoading) {
      return const LoadingView();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookingHeader(onClose: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SpecialistInfoSection(specialist: widget.specialist),
                  const Divider(height: 32),

                  // Show warning if user already has an appointment with this specialist
                  if (_bookingManager.hasExistingAppointmentWithSpecialist)
                    ExistingAppointmentWarning(
                      message: _bookingManager.errorMessage,
                      onViewAppointments: () {
                        context.pop();
                        context.push(AppRouters.kAppointmentsView);
                      },
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateSelectionSection(
                          selectedDate: _bookingManager.selectedDate,
                          onDateSelected: _bookingManager.updateSelectedDate,
                          isDateAvailable: _bookingManager.isDateAvailable,
                        ),
                        const SizedBox(height: 24),
                        TimeSelectionSection(
                          selectedDate: _bookingManager.selectedDate,
                          availableTimeSlots:
                              _bookingManager.availableTimeSlots,
                          selectedTimeSlot: _bookingManager.selectedTimeSlot,
                          onTimeSelected: _bookingManager.selectTimeSlot,
                          hasConflicts:
                              _bookingManager.hasConflictingAppointmentsOnDay,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          BookingConfirmationButton(
            isBookingEnabled: _bookingManager.canConfirmBooking,
            isLoading: _bookingManager.isSubmitting,
            price: widget.specialist.price,
            onBookingConfirmed: _onBookingConfirmed,
          ),
        ],
      ),
    );
  }

  Future<void> _onBookingConfirmed() async {
    final success = await _bookingManager.confirmBooking();

    if (success) {
      final formattedDate =
          DateFormat('EEEE, MMMM d, yyyy').format(_bookingManager.selectedDate);

      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        _showSuccessMessage(formattedDate);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_bookingManager.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessMessage(String formattedDate) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Appointment Booked',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'With ${widget.specialist.name} on $formattedDate at ${_bookingManager.selectedTimeSlot}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            context.push(AppRouters.kAppointmentsView);
          },
        ),
      ),
    );
  }
}
