import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esteshara/features/reset%20password/data/cubits/reset_password/reset_password_cubit.dart';
import 'package:esteshara/features/reset%20password/data/cubits/reset_password/reset_password_states.dart';
import 'package:esteshara/core/widgets/custom_button.dart';

class ResetPasswordButtonBlocBuilder extends StatelessWidget {
  const ResetPasswordButtonBlocBuilder({
    super.key,
    required this.emailController,
    required this.formKey,
  });

  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        return CustomButton(
          isLoading: state is ResetPasswordLoading ? true : false,
          buttonText: 'Reset Password',
          onPressed: () {
            final email = emailController.text;
            if (formKey.currentState!.validate()) {
              BlocProvider.of<ResetPasswordCubit>(context).resetPassword(email);
            }
          },
        );
      },
    );
  }
}
