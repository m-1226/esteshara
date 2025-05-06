import 'package:flutter/material.dart';

// Option 1: Professional Medical Theme
class AppColors {
  // Light mode
  static const Color kPrimaryColor =
      Color(0xFF2B6CB0); // Rich blue - trustworthy, professional
  static const Color kSecondaryColor =
      Color(0xFF4299E1); // Medium blue - slightly lighter
  static const Color kPrimaryVariant =
      Color(0xFF2C5282); // Darker blue for depth
  static const Color kBackgroundColor =
      Color(0xFFF7FAFC); // Off-white background - clean, medical
  static const Color kHighlightColor =
      Color(0xFFEDF2F7); // Light gray-blue for highlights
  static const Color kAccentColor =
      Color(0xFF38B2AC); // Teal accent - refreshing, healthcare association
  static const Color kErrorColor = Color(0xFFE53E3E); // Red for errors/alerts
  static const Color kTextPrimary = Color(0xFF1A202C); // Near-black for text
  static const Color kTextSecondary =
      Color(0xFF4A5568); // Dark gray for secondary text
  static const Color kWhite = Color(0xFFFFFFFF); // Pure white

  // Dark mode
  static const Color kDarkModeBackground = Color(0xFF1A202C); // Dark blue-gray
  static const Color kDarkPrimary =
      Color(0xFF2D3748); // Slightly lighter blue-gray
  static const Color kDarkSecondary = Color(0xFF4A5568); // Medium blue-gray
  static const Color kDarkAccent =
      Color(0xFF4FD1C5); // Brighter teal for dark mode
  static const Color kSelectedNavBarItemDarkMode = Color(0xFF4299E1);
  static const Color kDarkTextPrimary =
      Color(0xFFE2E8F0); // Light gray for text
  static const Color kDarkTextSecondary =
      Color(0xFFA0AEC0); // Medium gray for secondary text

  // Specialization colors
  static final Map<String, Color> specializationColors = {
    'Cardiologist': Colors.red.shade400,
    'Dermatologist': Colors.purple.shade400,
    'Pediatrician': Colors.green.shade400,
    'Business Consultant': Colors.blue.shade400,
    'Career Coach': Colors.orange.shade400,
    'Neurologist': Colors.indigo.shade400,
    'Psychiatrist': Colors.pink.shade400,
  };
}
