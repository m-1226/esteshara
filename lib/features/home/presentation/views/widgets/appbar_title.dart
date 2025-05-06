import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Available Specialists',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
