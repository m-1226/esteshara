import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.arrow_back, color: Colors.black87),
      ),
      onPressed: onPressed,
    );
  }
}
