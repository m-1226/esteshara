import 'package:esteshara/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeLight()) {
    _loadTheme();
  }

  void _loadTheme() async {
    var box = Hive.box(AppConstants.kHiveBox);
    final isLightTheme = box.get('isLightTheme', defaultValue: true);
    emit(isLightTheme ? const ThemeLight() : const ThemeDark());
  }

  void toggleTheme() {
    if (state is ThemeLight) {
      emit(const ThemeDark());
      _saveTheme(false);
    } else {
      emit(const ThemeLight());
      _saveTheme(true);
    }
  }

  Future<void> _saveTheme(bool isLightTheme) async {
    var box = Hive.box(AppConstants.kHiveBox);
    box.put('isLightTheme', isLightTheme);
  }
}
