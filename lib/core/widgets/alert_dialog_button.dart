import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AlertDialogButton extends StatelessWidget {
  const AlertDialogButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: AppStyles.bold18.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
