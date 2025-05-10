import 'package:esteshara/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class ResetPasswordImage extends StatelessWidget {
  const ResetPasswordImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesResetPassword,
      width: 170,
      height: 170,
    );
  }
}
