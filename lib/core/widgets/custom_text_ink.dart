import 'package:flutter/material.dart';

class CustomTextInk extends StatelessWidget {
  const CustomTextInk({
    super.key,
    required this.text1,
    this.onPressed,
    this.text2 = '',
  });

  final String text1;
  final String text2;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: text1,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 17,
                  ),
            ),
            TextSpan(
              text: text2,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 17,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
