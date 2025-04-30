import 'package:esteshara/core/utils/app_colors.dart';
import 'package:esteshara/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onFieldSubmitted,
    this.passwordController,
    this.validator,
    this.hintText,
  });
  final void Function(String)? onFieldSubmitted;
  final TextEditingController? passwordController;
  final String? Function(String?)? validator;
  final String? hintText;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      validator: widget.validator ??
          (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجي كتابة كلمة السر';
            }
            return null;
          },
      controller: widget.passwordController,
      obscureText: !isPasswordVisible,
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.kSecondaryColor,
        ),
        onPressed: () {
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        },
      ),
      hintText: widget.hintText ?? 'كلمة السر',
      textInputAction: TextInputAction.done,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
