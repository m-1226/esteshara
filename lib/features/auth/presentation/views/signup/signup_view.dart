import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/core/widgets/custom_info_message.dart';
import 'package:esteshara/core/widgets/errors/custom_error_message.dart';
import 'package:esteshara/features/auth/data/cubits/sign%20up/signup_cubit.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:esteshara/features/auth/presentation/views/signup/widgets/signup_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(authRepo: getIt<AuthRepo>()),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            context.push(AppRouters.kLoginView);
            customInfoMessage(
              context: context,
              title: 'تم إرسال بريد التفعيل',
              description: 'من فضلك إفحص صندوق البريد الخاص بك',
            );
          } else if (state is SignUpFailure) {
            customErrorMessage(title: state.errMessage);
          }
        },
        builder: (context, state) {
          return const Scaffold(
            body: SignUpViewBody(),
          );
        },
      ),
    );
  }
}
