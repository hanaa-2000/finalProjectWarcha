import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/extension.dart';
import 'package:warcha_final_progect/core/helper/show_toast_message.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/features/auth/logic/auth_cubit.dart';
import 'package:warcha_final_progect/features/auth/ui/login/screen/forget_password_screen.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({super.key});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool isVisibility = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          final userType = state.userType;
          if (userType == "client") {
            Navigator.pushNamedAndRemoveUntil(context,Routes.homeClient, (route) => false,);

            //context.pushReplacementNamed();
          } else {
            Navigator.pushNamedAndRemoveUntil(context, Routes.homeWorkshop, (route) => false,);
            // context.pushReplacementNamed();
          }
        }
        if (state is LoginFailure) {
          showToastMessage(context: context, message: state.errorMsg);
        }
      },
      builder: (context, state) {
        return Form(
          key: context.read<AuthCubit>().loginFormKey,
          child: Column(
            children: [
              SizedBox(height: 32.h),
              AppTextFormField(
                controller: context.read<AuthCubit>().emailController,
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_sharp, color: ColorApp.greyColor),
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return "Please enter your email";
                  }
                  return "";
                },
              ),
              SizedBox(height: 16.h),
              AppTextFormField(
                controller: context.read<AuthCubit>().passwordController,
                labelText: "Password",
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icon(Icons.password, color: ColorApp.greyColor),
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return "Please enter your Password";
                  }
                  return "";
                },

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisibility = !isVisibility;
                    });
                  },
                  icon: Icon(
                    isVisibility
                        ? Icons.visibility
                        : Icons.visibility_off_outlined,
                    color: ColorApp.greyColor,
                  ),
                ),
                obscureText: !isVisibility,
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgetPasswordScreen(),));
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forget Password?",
                    style: AppTextStyle.fontStyleBlue14400w,
                  ),
                ),
              ),
              SizedBox(height: 48.h),
              state is LoginLoading
                  ? Center(
                    child: CircularProgressIndicator(color: ColorApp.mainApp),
                  )
                  : CostumeButtonApp(
                    title: "Login",
                    onPressed: () {
                      if (!RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(
                        context.read<AuthCubit>().emailController.text,
                      )) {
                        showToastMessage(
                          context: context,
                          message: "Email address isn't valid",
                        );
                      } else if (context
                          .read<AuthCubit>()
                          .passwordController
                          .text
                          .isEmpty) {
                        showToastMessage(
                          context: context,
                          message: "Password is mandatory",
                        );
                      } else {
                        log("login");
                        context.read<AuthCubit>().SignIn();
                      }
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}
