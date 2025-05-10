import 'package:esteshara/core/widgets/errors/custom_error_message.dart';
import 'package:esteshara/core/widgets/success/custom_success_message.dart';
import 'package:esteshara/features/reset%20password/data/cubits/reset_password/reset_password_cubit.dart';
import 'package:esteshara/features/reset%20password/data/cubits/reset_password/reset_password_states.dart';
import 'package:esteshara/features/reset%20password/presentation/views/widgets/reset_password_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: BlocProvider(
        create: (context) => ResetPasswordCubit(),
        child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              customSuccessMessage(
                title: 'Password reset email sent successfully',
              );
            } else if (state is ResetPasswordFailure) {
              customErrorMessage(title: state.errMessage);
            }
          },
          child: const ResetPasswordViewBody(),
        ),
      ),
    );
  }
}
