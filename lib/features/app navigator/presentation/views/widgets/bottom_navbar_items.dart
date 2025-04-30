import 'package:esteshara/features/app%20navigator/presentation/views/widgets/build_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

List<PersistentRouterTabConfig> bottomNavBarItems(BuildContext context) {
  return [
    buildNavBarItem(
      context: context,
      icon: const Icon(Icons.dashboard),
      title: "الرئيسية",
    ),
    buildNavBarItem(
      context: context,
      icon: const Icon(Icons.account_circle),
      title: "المواعيد",
    ),
  ];
}
