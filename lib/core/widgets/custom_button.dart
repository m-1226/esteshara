import 'package:flutter/material.dart';
import 'package:esteshara/core/utils/app_colors.dart';
import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/core/widgets/custom_loading_indicator.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressed;
  final bool isLoading;
  final Widget? icon;
  final Color? buttonColor;

  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: buttonColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 0.5,
            color: Colors.black,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null) icon!,
            Expanded(
              child: Center(
                child: isLoading
                    ? CustomLoadingIndicator(
                        size: 27,
                        color: AppColors.kSecondaryColor,
                      )
                    : Text(
                        buttonText,
                        style: AppStyles.bold16
                            .copyWith(color: AppColors.kSecondaryColor),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
