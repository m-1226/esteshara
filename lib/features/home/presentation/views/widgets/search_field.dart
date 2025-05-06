import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search specialists...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      style: const TextStyle(color: Colors.black),
      onChanged: onChanged,
      autofocus: true,
    );
  }
}
