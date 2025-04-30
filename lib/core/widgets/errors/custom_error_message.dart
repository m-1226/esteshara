import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void customErrorMessage({required String title, String? description}) {
  toastification.show(
    type: ToastificationType.error,
    style: ToastificationStyle.fillColored,
    borderRadius: BorderRadius.circular(15),
    closeOnClick: true,
    showProgressBar: false,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(
      title,
      style: AppStyles.bold14,
    ),
  );
}
