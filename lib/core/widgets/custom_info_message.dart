import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void customInfoMessage({
  required BuildContext context,
  required String title,
  String? description,
}) {
  toastification.show(
    type: ToastificationType.info,
    style: ToastificationStyle.fillColored,
    showProgressBar: false,
    autoCloseDuration: const Duration(seconds: 10),
    closeOnClick: true,
    context: context,
    title: Text(title),
    description: Text(description ?? ''),
    borderRadius: BorderRadius.circular(15),
  );
}
