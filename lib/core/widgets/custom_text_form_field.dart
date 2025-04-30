import 'package:esteshara/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.readOnly,
    this.onChanged,
    this.hintText,
    this.focusNode,
    this.textAlign,
    this.textDirection,
    this.onTap,
    this.maxLines,
    this.horizontalPadding,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final int? maxLines;
  final double? horizontalPadding;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    double defaultRadius = 10;
    return TextFormField(
      style: AppStyles.regular14.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      onTap: onTap,
      textInputAction: textInputAction,
      textDirection: textDirection,
      textAlign: textAlign ?? TextAlign.right,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: horizontalPadding ?? 0,
        ),
        fillColor: Colors.grey[200],
        filled: true,
        prefixIcon: prefixIcon,
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        labelText: labelText,
        hintText: hintText,
        hintStyle: AppStyles.notoKufiGreyStyle14,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        enabled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
        errorStyle: AppStyles.notoKufiGreyStyle14.copyWith(
          color: Colors.red,
        ),
      ),
    );
  }
}
