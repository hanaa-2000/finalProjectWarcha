import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcha_final_progect/core/helper/extension.dart';
import 'package:warcha_final_progect/core/helper/show_toast_message.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/features/auth/logic/auth_cubit.dart';

class SignupTextField extends StatefulWidget {
  const SignupTextField({super.key});

  @override
  State<SignupTextField> createState() => _SignupTextFieldState();
}

class _SignupTextFieldState extends State<SignupTextField> {
  bool isVisibility = false;

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<AuthCubit>().userType;
    print("✅ Loaded userType: $userType");
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          showToastMessage(
            context: context,
            message: "Welcommmmmmm   $userType",
          );

          if (userType == "client") {
            Navigator.pushNamedAndRemoveUntil(context, Routes.homeClient, (route) => false,);
            //context.pushReplacementNamed(Routes.homeClient);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, Routes.homeWorkshop, (route) => false,);

           // context.pushReplacementNamed(Routes.);
          }
        }
        if (state is SignUpFailure) {
          showToastMessage(context: context, message: state.errorMsg);
        }
      },
      builder: (context, state) {
        return Form(
          key: context.read<AuthCubit>().formKey,
          child: Column(
            children: [
              AppTextFormField(
                controller: context.read<AuthCubit>().userNameController,
                labelText: "Username",
                keyboardType: TextInputType.name,
                prefixIcon: Icon(Icons.person, color: ColorApp.greyColor),
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return "Please enter your Username";
                  }
                  return "";
                },
              ),
              SizedBox(height: 16.h),
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
                controller: context.read<AuthCubit>().phoneController,
                labelText: "Phone",
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone, color: ColorApp.greyColor),
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return "Please enter your Phone";
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
              SizedBox(height: 32.h),
              state is SignUpLoading
                  ? Center(
                    child: CircularProgressIndicator(color: ColorApp.mainApp),
                  )
                  : CostumeButtonApp(
                    title: "Sign Up",
                    onPressed: () {
                      if (context
                          .read<AuthCubit>()
                          .userNameController
                          .text
                          .isEmpty) {
                        showToastMessage(
                          context: context,
                          message: "Name isn't Empty",
                        );
                      } else if (!RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(
                        context.read<AuthCubit>().emailController.text,
                      )) {
                        showToastMessage(
                          context: context,
                          message: "Email address isn't valid",
                        );
                      } else if (!RegExp(r'^01[0-2,5][0-9]{8}$').hasMatch(
                        context.read<AuthCubit>().phoneController.text,
                      )) {
                        showToastMessage(
                          context: context,
                          message: "Phone must be 11 digits starting with 01",
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
                        log("signUp");
                        context.read<AuthCubit>().signUp(usertype: userType);
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
