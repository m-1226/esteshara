import 'package:esteshara/features/auth/presentation/views/login/widgets/email_field.dart';
import 'package:esteshara/features/reset%20password/presentation/views/widgets/reset_password_button_bloc_builder.dart';
import 'package:esteshara/features/reset%20password/presentation/views/widgets/reset_password_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ResetPasswordViewBody extends StatefulWidget {
  const ResetPasswordViewBody({super.key});

  @override
  State<ResetPasswordViewBody> createState() => _ResetPasswordViewBodyState();
}

class _ResetPasswordViewBodyState extends State<ResetPasswordViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: Form(
        autovalidateMode: autovalidateMode,
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResetPasswordImage(),
            Gap(25),
            EmailField(emailController: emailController),
            Gap(15),
            ResetPasswordButtonBlocBuilder(
                emailController: emailController, formKey: formKey),
          ],
        ),
      ),
    );
  }
}
