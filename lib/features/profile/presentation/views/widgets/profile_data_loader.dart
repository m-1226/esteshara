// features/profile/presentation/views/widgets/profile_data_loader.dart
import 'package:esteshara/core/models/appointment_model.dart';
import 'package:esteshara/core/models/user_model.dart';
import 'package:esteshara/core/services/firebase_service.dart';
import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:flutter/material.dart';

/// A widget that loads user profile data and provides it to its children
class ProfileDataLoader extends StatefulWidget {
  /// The user ID to load data for
  final String userId;

  /// Builder function that receives the loaded data
  final Widget Function(BuildContext context, UserModel? userModel,
      bool isLoading, String? error) builder;

  const ProfileDataLoader({
    super.key,
    required this.userId,
    required this.builder,
  });

  @override
  State<ProfileDataLoader> createState() => _ProfileDataLoaderState();
}

class _ProfileDataLoaderState extends State<ProfileDataLoader> {
  final FirebaseService _firebaseService = getIt<FirebaseService>();

  UserModel? _userModel;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didUpdateWidget(ProfileDataLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload data if user ID changes
    if (oldWidget.userId != widget.userId) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(widget.userId)
          .get();

      if (!userDoc.exists) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = 'User profile not found';
            _userModel = null;
          });
        }
        return;
      }

      // Convert to UserModel
      final userData = userDoc.data() as Map<String, dynamic>;
      final UserModel userModel = _convertToUserModel(userDoc.id, userData);

      if (mounted) {
        setState(() {
          _userModel = userModel;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load profile data: $e';
        });
      }
    }
  }

  UserModel _convertToUserModel(String id, Map<String, dynamic> data) {
    // Extract appointments and convert them properly
    List<dynamic> appointments = [];
    if (data['appointments'] != null) {
      appointments = data['appointments'];
    }

    // Extract favorite specialists
    List<String> favoriteSpecialistIds = [];
    if (data['favoriteSpecialistIds'] != null) {
      favoriteSpecialistIds = List<String>.from(data['favoriteSpecialistIds']);
    }

    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      favoriteSpecialistIds: favoriteSpecialistIds,
      appointments: appointments.map((appointment) => AppointmentModel.fromMap(appointment)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _userModel,
      _isLoading,
      _error,
    );
  }
}
