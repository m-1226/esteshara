import 'package:esteshara/features/app%20navigator/presentation/views/widgets/build_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
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
      icon: const Icon(Icons.notification_add),
      title: "الإشعارات",
    ),
    buildNavBarItem(
      context: context,
      icon: const Icon(Ionicons.library),
      title: "المكتبة",
    ),
    buildNavBarItem(
      context: context,
      icon: const Icon(Icons.book),
      title: "الكتب",
    ),
    buildNavBarItem(
      context: context,
      icon: const Icon(Icons.workspace_premium),
      title: "الإشتراكات",
    ),
  ];
}
