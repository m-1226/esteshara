import 'package:esteshara/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.imageSize,
  });
  final double? imageSize;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesAppLogo,
      width: imageSize ?? 250,
      height: imageSize ?? 250,
    );
  }
}
