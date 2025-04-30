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
          return 'يرجى كتابة الإيميل';
        } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(value)) {
          return 'يرجي كتابة الإيميل بشكل صحيح';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      prefixIcon: const Icon(Icons.person),
      hintText: 'الإيميل',
      textInputAction: TextInputAction.next,
    );
  }
}
