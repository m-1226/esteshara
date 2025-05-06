import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/core/widgets/alert_dialog_button.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? description;

  final VoidCallback? onPressedBtn1;
  final VoidCallback? onPressedBtn2;
  final String? textBtn1;
  final String? textBtn2;

  const CustomAlertDialog({
    super.key,
    required this.title,
    this.onPressedBtn1,
    this.onPressedBtn2,
    this.textBtn1,
    this.textBtn2,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.info,
        size: 50,
        color: Colors.red,
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: AppStyles.bold18.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      content: Visibility(
        visible: description != null,
        child: Text(
          description ?? '',
          textAlign: TextAlign.center,
          style: AppStyles.bold14.copyWith(
            fontSize: 12,
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AlertDialogButton(
              onPressed: onPressedBtn1,
              text: textBtn1 ?? 'نعم',
              textColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            AlertDialogButton(
              onPressed: onPressedBtn2,
              text: textBtn2 ?? 'لا',
              textColor: Colors.black,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ],
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
