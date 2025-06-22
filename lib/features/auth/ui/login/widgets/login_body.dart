import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/auth/logic/auth_cubit.dart';
import 'package:warcha_final_progect/features/auth/ui/icon_widget.dart';
import 'package:warcha_final_progect/features/auth/ui/login/widgets/build_row_sign_in.dart';
import 'package:warcha_final_progect/features/auth/ui/login/widgets/login_text_field.dart';
import 'package:warcha_final_progect/features/auth/ui/login/widgets/text_info_term.dart';
import 'package:warcha_final_progect/features/auth/ui/login/widgets/welcome_login_text.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            final userType = state.userType;
            if (userType == "client") {
              Navigator.pushNamedAndRemoveUntil(context,Routes.homeClient, (route) => false,);
              //context.pushReplacementNamed();
            } else {
              Navigator.pushNamedAndRemoveUntil(context, Routes.homeWorkshop, (route) => false,);
              // context.pushReplacementNamed();
            }
            print("objectllllllllllll");

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('مرحبًا ${state.user.displayName}')));

          } else if (state is AuthFailure) {
            print("${state.message}.lllllllllllllllllllllllllllllllllllllll");
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
            if (state is AuthLoading) {
                return CustomLoadingWidget();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WelcomeLoginText(),
                    SizedBox(height: 48.h,),
                    LoginTextField(),
                    SizedBox(height: 48.h,),
                    BuildRowSignIn(),
                    SizedBox(height: 24.h,),
                    IconWidget(),
                    SizedBox(height: 24.h,),
                    TextInfoTerm(),

                  ],
                ),
              );
            },
          )


    );
  }
}
