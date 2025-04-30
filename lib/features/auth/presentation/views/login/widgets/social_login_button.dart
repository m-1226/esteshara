import 'package:flutter/material.dart';
import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/core/widgets/custom_loading_indicator.dart';

class SocialLoginButton extends StatelessWidget {
  final Function()? onPressed;
  final bool isLoading;
  final Widget icon;
  final String buttonText;
  final Color progressColor;

  const SocialLoginButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    required this.icon,
    required this.buttonText,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50, // Fixed height for a consistent look
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: .5,
            color: Colors.black,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          textDirection: TextDirection.rtl, // Moves the icon to the right
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Expanded(
              child: Center(
                child: isLoading
                    ? CustomLoadingIndicator(
                        size: 27,
                        color: progressColor,
                      )
                    : Text(
                        buttonText,
                        style: AppStyles.bold16,
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
