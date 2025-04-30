import 'package:esteshara/core/utils/app_colors.dart';
import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.kPrimaryColor,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.kPrimaryColor,
      ),
      titleTextStyle: AppStyles.bold18.copyWith(
        color: AppColors.kSecondaryColor,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 30,
      ),
      centerTitle: true,
      actionsIconTheme: const IconThemeData(
        size: 30,
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.kPrimaryColor,
      secondary: AppColors.kSecondaryColor,
      tertiary: AppColors.kPrimaryColor,
    ),
    textTheme: TextTheme(
      titleLarge: AppStyles.bold18.copyWith(
        fontSize: 20,
        color: AppColors.kSecondaryColor,
      ),
      titleMedium: AppStyles.notoKufiGreyStyle14.copyWith(
        fontSize: 14,
        color: AppColors.kSecondaryColor,
      ),
      titleSmall: AppStyles.notoKufiGreyStyle14.copyWith(
        color: Colors.grey,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: AppColors.kPrimaryColor,
      cursorColor: AppColors.kPrimaryColor,
      selectionColor: AppColors.kPrimaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.kPrimaryColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.kDarkPrimary,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.kDarkPrimary,
      ),
      titleTextStyle: AppStyles.bold18.copyWith(
        color: AppColors.kSecondaryColor,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 30,
      ),
      centerTitle: true,
      actionsIconTheme: const IconThemeData(
        size: 30,
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      surface: AppColors.kDarkSecondary,
      primary: AppColors.kSecondaryColor,
      secondary: AppColors.kSecondaryColor,
      tertiary: AppColors.kDarkPrimary,
    ),
    textTheme: TextTheme(
      titleLarge: AppStyles.bold18.copyWith(
        fontSize: 20,
        color: AppColors.kWhite,
      ),
      titleMedium: AppStyles.regular14.copyWith(
        color: AppColors.kSecondaryColor,
      ),
      titleSmall: AppStyles.notoKufiGreyStyle14.copyWith(
        color: AppColors.kHighlightColor,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: AppColors.kSecondaryColor,
      cursorColor: AppColors.kSecondaryColor,
      selectionColor: AppColors.kSecondaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(
        color: AppColors.kSelectedNavBarItemDarkMode,
      ),
      backgroundColor: AppColors.kDarkModeBackground,
      selectedItemColor: AppColors.kSelectedNavBarItemDarkMode,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.kDarkModeBackground,
    ),
    scaffoldBackgroundColor: AppColors.kDarkModeBackground,
    cardColor: AppColors.kDarkPrimary,
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.kDarkSecondary,
    ),
  );
}
