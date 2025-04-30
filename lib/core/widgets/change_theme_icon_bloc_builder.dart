import 'package:esteshara/core/cubits/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class ChangeThemeIconBuilder extends StatelessWidget {
  const ChangeThemeIconBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeCubit = BlocProvider.of<ThemeCubit>(context);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        IconData icon = state is ThemeLight
            ? Ionicons.moon_outline
            : Icons.light_mode_rounded;

        return IconButton(
          onPressed: () {
            themeCubit.toggleTheme();
          },
          icon: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      },
    );
  }
}
