import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/core/widgets/custom_button.dart' show CustomButton;
import 'package:esteshara/core/widgets/custom_text_ink.dart';
import 'package:esteshara/features/auth/data/cubits/sign%20up/signup_cubit.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/email_field.dart';
import 'package:esteshara/features/auth/presentation/views/login/widgets/password_field.dart';
import 'package:esteshara/features/auth/presentation/views/signup/widgets/user_name_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          UsernameField(
            usernameController: usernameController,
          ),
          const SizedBox(
            height: 10,
          ),
          EmailField(
            emailController: emailController,
          ),
          const SizedBox(
            height: 10,
          ),
          PasswordField(
            passwordController: passwordController,
          ),
          const SizedBox(
            height: 10,
          ),
          PasswordField(
            hintText: 'تأكيد كلمة السر',
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'يرجي تأكيد كلمة السر';
              } else if (value != passwordController.text) {
                return 'كلمة السر غير متطابقة';
              }
              return null;
            },
            passwordController: confirmPasswordController,
          ),
          Gap(30),
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return CustomButton(
                isLoading: state is SignUpLoading,
                buttonText: 'إنشاء حساب',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    BlocProvider.of<SignUpCubit>(context).signUp(
                        emailController.text,
                        passwordController.text,
                        usernameController.text);
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
              );
            },
          ),
          const Gap(20),
          CustomTextInk(
            text1: 'لديك حساب؟  ',
            text2: 'تسجيل الدخول',
            onPressed: () {
              context.pushReplacement(AppRouters.kLoginView);
            },
          ),
        ],
      ),
    );
  }
}
