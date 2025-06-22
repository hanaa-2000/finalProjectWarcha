import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:warcha_final_progect/core/helper/show_toast_message.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/auth/logic/auth_cubit.dart';

class IconWidget extends StatefulWidget {
  const IconWidget({super.key});

  @override
  State<IconWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
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
        }
        if (state is AuthFailure) {
          showToastMessage(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        // if (state is AuthLoading) {
        //   return CustomLoadingWidget();
        // }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap:()=>context.read<AuthCubit>().signInWithGoogle(),

              child: Container(
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: Color(0xffF5F5F5),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/google.png", width: 32.w, height: 32.h,),
                ),
              ),
            ),
            SizedBox(width: 20.w,),
            GestureDetector(
              onTap:()=>context.read<AuthCubit>().signInWithFacebook(),
              child: Container(
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: Color(0xffF5F5F5),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/face.png", width: 32.w, height: 32.h,),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}



