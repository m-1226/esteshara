part of 'theme_cubit.dart';

@immutable
abstract class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class ThemeLight extends ThemeState {
  const ThemeLight() : super(ThemeMode.light);
}

class ThemeDark extends ThemeState {
  const ThemeDark() : super(ThemeMode.dark);
}
