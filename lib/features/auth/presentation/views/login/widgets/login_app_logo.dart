import 'package:esteshara/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class LoginAppLogo extends StatelessWidget {
  const LoginAppLogo({
    super.key,
    this.imageSize,
    this.color,
  });
  final double? imageSize;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesLoginAppLogo,
      width: imageSize ?? 250,
      height: imageSize ?? 250,
      color: color,
    );
  }
}
