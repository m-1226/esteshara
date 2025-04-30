import 'package:esteshara/features/auth/data/cubits/login/login_cubit.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/social_login_button.dart';
import 'package:esteshara/utils/app_assets.dart/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GoogleLoginButtonBlocBuilder extends StatelessWidget {
  const GoogleLoginButtonBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return SocialLoginButton(
          progressColor: Colors.green,
          buttonText: 'تسجيل الدخول Google',
          icon: Image.asset(
            Assets.imagesGoogle,
            width: 25,
            height: 25,
          ),
          isLoading: state is LoginGoogleLoading,
          onPressed: () {
            // BlocProvider.of<LoginCubit>(context).signInWithGoogle();
          },
        );
      },
    );
  }
}
