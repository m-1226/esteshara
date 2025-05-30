import 'package:esteshara/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
    required this.usernameController,
  });

  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: 'Username',
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter a username';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.left,
      controller: usernameController,
      prefixIcon: const Icon(
        Icons.person,
      ),
    );
  }
}
