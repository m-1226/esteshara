import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void customSuccessMessage({required title}) {
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    borderRadius: BorderRadius.circular(15),
    closeOnClick: true,
    showProgressBar: false,
    autoCloseDuration: const Duration(seconds: 7),
    title: Text(title, style: AppStyles.bold14.copyWith(color: Colors.white)),
  );
}
