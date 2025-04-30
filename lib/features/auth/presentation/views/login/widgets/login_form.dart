import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/core/widgets/custom_button.dart';
import 'package:esteshara/core/widgets/custom_text_form_field.dart';
import 'package:esteshara/core/widgets/custom_text_ink.dart';
import 'package:esteshara/features/auth/data/cubits/login/login_cubit.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      BlocProvider.of<LoginCubit>(context).loginWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          CustomTextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى كتابة الإيميل';
              } else if (!RegExp(
                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
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
          ),
          Gap(10),
          PasswordField(
            controller: passwordController,
            onFieldSubmitted: (_) => submitForm(),
          ),
          Gap(15),
          CustomTextInk(
            text1: 'نسيت كلمة المرور؟',
            onPressed: () {
              // context.push(AppRouter.kResetPasswordView);
            },
          ),
          const SizedBox(height: 15),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return CustomButton(
                isLoading: state is LoginLoading,
                buttonText: 'تسجيل الدخول',
                onPressed: submitForm,
              );
            },
          ),
          const SizedBox(height: 15),
          // GoogleLoginButtonBlocBuilder(),
          const SizedBox(height: 20),
          CustomTextInk(
            text1: 'ليس لديك حساب؟  ',
            text2: 'سجل الأن',
            onPressed: () {
              context.pushReplacement(AppRouters.kSignupView);
            },
          ),
        ],
      ),
    );
  }
}
