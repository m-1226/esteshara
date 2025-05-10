import 'package:esteshara/core/utils/app_assets.dart';
import 'package:esteshara/core/widgets/custom_button.dart';
import 'package:esteshara/core/widgets/custom_text_form_field.dart';
import 'package:esteshara/features/reset%20password/data/cubits/reset_password/reset_password_cubit.dart';
import 'package:esteshara/features/reset%20password/data/cubits/reset_password/reset_password_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            Image.asset(
              Assets.imagesResetPassword,
              width: 170,
              height: 170,
            ),
            const SizedBox(
              height: 25,
            ),
            CustomTextFormField(
              hintText: 'إكتب الإيميل المسجل علي التطبيق',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى كتابة الإيميل';
                } else if (!RegExp(
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                    .hasMatch(value)) {
                  return 'يرجي الإيميل بشكل صحيح';
                }
                return null;
              },
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(
              height: 15,
            ),
            BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              builder: (context, state) {
                return CustomButton(
                  isLoading: state is ResetPasswordLoading ? true : false,
                  buttonText: 'إستعادة كلمة المرور',
                  onPressed: () {
                    final email = emailController.text;
                    if (formKey.currentState!.validate()) {
                      BlocProvider.of<ResetPasswordCubit>(context)
                          .resetPassword(email);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
