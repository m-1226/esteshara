import 'package:esteshara/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(value)) {
          return 'Email is invalid';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      textAlign: TextAlign.left,
      prefixIcon: const Icon(Icons.email),
      hintText: 'Email Address',
      textInputAction: TextInputAction.next,
    );
  }
}
