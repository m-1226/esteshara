import 'package:esteshara/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.phoneController,
  });

  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: 'Phone Number',
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter a phone number';
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      textAlign: TextAlign.left,
      controller: phoneController,
      prefixIcon: const Icon(
        Icons.phone,
      ),
    );
  }
}
