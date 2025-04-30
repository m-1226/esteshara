import 'package:esteshara/features/app%20navigator/presentation/views/widgets/bottom_navbar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final navBarColor =
        Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
        Colors.white;
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.appBarTheme.systemOverlayStyle!.statusBarColor,
        statusBarIconBrightness:
            theme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: PersistentTabView.router(
          avoidBottomPadding: true,
          navBarHeight: 60,
          navBarOverlap: NavBarOverlap.none(),
          navigationShell: navigationShell,
          backgroundColor: navBarColor,
          navBarBuilder:
              (navBarConfig) => Style12BottomNavBar(
                navBarDecoration: NavBarDecoration(color: navBarColor),
                navBarConfig: navBarConfig,
              ),
          tabs: bottomNavBarItems(context),
        ),
      ),
    );
  }
}
