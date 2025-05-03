import 'package:esteshara/core/utils/app_colors.dart';
import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.kPrimaryColor,
    scaffoldBackgroundColor: AppColors.kBackgroundColor,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.kPrimaryColor,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.kPrimaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: AppStyles.bold18.copyWith(
        color: AppColors.kWhite,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.kWhite,
        size: 24,
      ),
      centerTitle: true,
      actionsIconTheme: const IconThemeData(
        size: 24,
        color: AppColors.kWhite,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.kPrimaryColor,
      secondary: AppColors.kSecondaryColor,
      tertiary: AppColors.kPrimaryVariant,
      error: AppColors.kErrorColor,
      surface: AppColors.kWhite,
      onPrimary: AppColors.kWhite,
      onSecondary: AppColors.kWhite,
      onSurface: AppColors.kTextPrimary,
      onError: AppColors.kWhite,
    ),
    textTheme: TextTheme(
      displayLarge: AppStyles.bold18.copyWith(
        fontSize: 26,
        color: AppColors.kTextPrimary,
      ),
      displayMedium: AppStyles.bold18.copyWith(
        fontSize: 22,
        color: AppColors.kTextPrimary,
      ),
      displaySmall: AppStyles.bold18.copyWith(
        fontSize: 20,
        color: AppColors.kTextPrimary,
      ),
      headlineMedium: AppStyles.bold18.copyWith(
        fontSize: 18,
        color: AppColors.kTextPrimary,
      ),
      titleLarge: AppStyles.bold18.copyWith(
        fontSize: 16,
        color: AppColors.kTextPrimary,
      ),
      titleMedium: AppStyles.regular14.copyWith(
        fontSize: 14,
        color: AppColors.kTextSecondary,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: AppStyles.regular14.copyWith(
        fontSize: 12,
        color: AppColors.kTextSecondary,
      ),
      bodyLarge: AppStyles.regular14.copyWith(
        fontSize: 16,
        color: AppColors.kTextPrimary,
      ),
      bodyMedium: AppStyles.regular14.copyWith(
        fontSize: 14,
        color: AppColors.kTextPrimary,
      ),
      bodySmall: AppStyles.regular14.copyWith(
        fontSize: 12,
        color: AppColors.kTextSecondary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.kHighlightColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.kPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.kErrorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.kErrorColor, width: 1.5),
      ),
      hintStyle: AppStyles.regular14.copyWith(
        color: AppColors.kTextSecondary.withOpacity(0.7),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: AppColors.kPrimaryColor,
      cursorColor: AppColors.kPrimaryColor,
      selectionColor: AppColors.kPrimaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: AppColors.kWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppStyles.bold18.copyWith(
          fontSize: 16,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.kPrimaryColor,
        side: const BorderSide(color: AppColors.kPrimaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppStyles.bold18.copyWith(
          fontSize: 16,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.kPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        textStyle: AppStyles.regular14.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.kWhite,
      selectedItemColor: AppColors.kPrimaryColor,
      unselectedItemColor: AppColors.kTextSecondary,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppStyles.regular14.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: AppStyles.regular14.copyWith(
        fontSize: 12,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.kHighlightColor,
      disabledColor: AppColors.kHighlightColor.withOpacity(0.5),
      selectedColor: AppColors.kPrimaryColor,
      secondarySelectedColor: AppColors.kSecondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: AppStyles.regular14.copyWith(
        color: AppColors.kTextPrimary,
      ),
      secondaryLabelStyle: AppStyles.regular14.copyWith(
        color: AppColors.kWhite,
      ),
      brightness: Brightness.light,
    ),
    cardTheme: CardTheme(
      color: AppColors.kWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: AppColors.kPrimaryColor.withOpacity(0.1),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.kWhite,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
      space: 24,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.kPrimaryColor,
      circularTrackColor: Color(0xFFEDF2F7),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.kTextPrimary,
      contentTextStyle: AppStyles.regular14.copyWith(
        color: AppColors.kWhite,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.kWhite,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.kWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.kPrimaryColor,
    scaffoldBackgroundColor: AppColors.kDarkModeBackground,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.kDarkPrimary,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.kDarkPrimary,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: AppStyles.bold18.copyWith(
        color: AppColors.kDarkTextPrimary,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.kDarkTextPrimary,
        size: 24,
      ),
      centerTitle: true,
      actionsIconTheme: const IconThemeData(
        size: 24,
        color: AppColors.kDarkTextPrimary,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.kPrimaryColor,
      secondary: AppColors.kSecondaryColor,
      tertiary: AppColors.kDarkAccent,
      error: AppColors.kErrorColor,
      surface: AppColors.kDarkPrimary,
      onPrimary: AppColors.kDarkTextPrimary,
      onSecondary: AppColors.kDarkTextPrimary,
      onSurface: AppColors.kDarkTextPrimary,
      onError: AppColors.kWhite,
    ),
    textTheme: TextTheme(
      displayLarge: AppStyles.bold18.copyWith(
        fontSize: 26,
        color: AppColors.kDarkTextPrimary,
      ),
      displayMedium: AppStyles.bold18.copyWith(
        fontSize: 22,
        color: AppColors.kDarkTextPrimary,
      ),
      displaySmall: AppStyles.bold18.copyWith(
        fontSize: 20,
        color: AppColors.kDarkTextPrimary,
      ),
      headlineMedium: AppStyles.bold18.copyWith(
        fontSize: 18,
        color: AppColors.kDarkTextPrimary,
      ),
      titleLarge: AppStyles.bold18.copyWith(
        fontSize: 16,
        color: AppColors.kDarkTextPrimary,
      ),
      titleMedium: AppStyles.regular14.copyWith(
        fontSize: 14,
        color: AppColors.kDarkTextSecondary,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: AppStyles.regular14.copyWith(
        fontSize: 12,
        color: AppColors.kDarkTextSecondary,
      ),
      bodyLarge: AppStyles.regular14.copyWith(
        fontSize: 16,
        color: AppColors.kDarkTextPrimary,
      ),
      bodyMedium: AppStyles.regular14.copyWith(
        fontSize: 14,
        color: AppColors.kDarkTextPrimary,
      ),
      bodySmall: AppStyles.regular14.copyWith(
        fontSize: 12,
        color: AppColors.kDarkTextSecondary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.kDarkPrimary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.kSecondaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.kErrorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.kErrorColor, width: 1.5),
      ),
      hintStyle: AppStyles.regular14.copyWith(
        color: AppColors.kDarkTextSecondary.withOpacity(0.7),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: AppColors.kSecondaryColor,
      cursorColor: AppColors.kSecondaryColor,
      selectionColor: AppColors.kSecondaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: AppColors.kWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppStyles.bold18.copyWith(
          fontSize: 16,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.kSecondaryColor,
        side: const BorderSide(color: AppColors.kSecondaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppStyles.bold18.copyWith(
          fontSize: 16,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.kSecondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        textStyle: AppStyles.regular14.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.kDarkPrimary,
      selectedItemColor: AppColors.kSelectedNavBarItemDarkMode,
      unselectedItemColor: AppColors.kDarkTextSecondary,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppStyles.regular14.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: AppStyles.regular14.copyWith(
        fontSize: 12,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.kDarkPrimary,
      disabledColor: AppColors.kDarkPrimary.withOpacity(0.5),
      selectedColor: AppColors.kSecondaryColor,
      secondarySelectedColor: AppColors.kDarkAccent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: AppStyles.regular14.copyWith(
        color: AppColors.kDarkTextPrimary,
      ),
      secondaryLabelStyle: AppStyles.regular14.copyWith(
        color: AppColors.kDarkTextPrimary,
      ),
      brightness: Brightness.dark,
    ),
    cardTheme: CardTheme(
      color: AppColors.kDarkPrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.kDarkPrimary,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF4A5568),
      thickness: 1,
      space: 24,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.kSecondaryColor,
      circularTrackColor: Color(0xFF2D3748),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.kDarkSecondary,
      contentTextStyle: AppStyles.regular14.copyWith(
        color: AppColors.kDarkTextPrimary,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.kDarkModeBackground,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.kDarkPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    ),
  );
}
