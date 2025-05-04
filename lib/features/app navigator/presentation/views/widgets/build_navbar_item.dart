import 'package:esteshara/core/utils/app_colors.dart';
import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

PersistentRouterTabConfig buildNavBarItem({
  required BuildContext context,
  required String title,
  required Widget icon,
  Widget? inActiveIcon,
}) {
  return PersistentRouterTabConfig(
    item: ItemConfig(

      activeForegroundColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
          AppColors.kPrimaryColor,
      activeColorSecondary: Colors.transparent,
      inactiveIcon: inActiveIcon,
      icon: icon,
      title: title,
      textStyle: AppStyles.bold14,
    ),
  );
}
