import 'package:esteshara/features/app%20navigator/presentation/views/widgets/build_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

List<PersistentRouterTabConfig> bottomNavBarItems(BuildContext context) {
  return [
    buildNavBarItem(
      context: context,
      icon: const Icon(Icons.medical_services_rounded),
      title: "Home",
    ),
    buildNavBarItem(
      context: context,
      icon: const Icon(Icons.calendar_today_rounded),
      title: "Appointments",
    ),
    buildNavBarItem(
      context: context,
      icon: const Icon(Icons.account_circle_rounded),
      title: "Profile",
    ),
  ];
}
