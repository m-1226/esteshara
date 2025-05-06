import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/features/appointments/presentation/views/widgets/reschedule_appointment_dialog.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_cubit.dart';
import 'package:esteshara/features/home/data/cubits/get_specialist/get_specialist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RescheduleDialogContent extends StatelessWidget {
  final AppointmentModel appointment;
  final Function(DateTime, String) onReschedule;

  const RescheduleDialogContent({
    super.key,
    required this.appointment,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSpecialistsCubit, GetSpecialistsState>(
      builder: (_, state) {
        if (state is SpecialistsLoading || state is SpecialistsInitial) {
          return _buildLoadingState();
        } else if (state is SpecialistsError) {
          return _buildErrorState(context, state.message);
        } else if (state is SpecialistsLoaded) {
          try {
            final specialist = state.specialists.firstWhere(
              (s) => s.id == appointment.specialistId,
            );
            return RescheduleAppointmentDialog(
              specialist: specialist,
              appointment: appointment,
              onReschedule: onReschedule,
            );
          } catch (e) {
            return _buildSpecialistNotFoundState(context);
          }
        }
        return _buildLoadingState();
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(minHeight: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 48,
            width: 48,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading Specialist Data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(minHeight: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade400,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistNotFoundState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(minHeight: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            color: Colors.red.shade400,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Specialist not found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The specialist for this appointment could not be found. Please try again later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
