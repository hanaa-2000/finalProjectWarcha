import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/extension.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class TextInfoTerm  extends StatelessWidget {
  const TextInfoTerm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
           textScaleFactor:1.03,
            text:TextSpan(

              children: [
                TextSpan(
                     text: "By logging, you agree to our ",
                      style: AppTextStyle.fontStyleGrey14400w,
                ),
                TextSpan(
                  text: "Terms & Conditions ",
                  style: AppTextStyle.fontStyleGrey14400w.copyWith(color: Colors.black)
                ),
                TextSpan(
                  text: "and ",
                  style:AppTextStyle.fontStyleGrey14400w

                ),
                TextSpan(
                  text: "PrivacyPolicy.",
                  style:AppTextStyle.fontStyleGrey14400w.copyWith(color: Colors.black)
                ),
              ]
            )
        ),
        SizedBox(height:32.h,),
         GestureDetector(
           onTap: () {
             context.pushNamed(Routes.signUp);
           },
           child: RichText(
              textAlign: TextAlign.center,
                  text:TextSpan(

                  children: [
                    TextSpan(
                      text: "Don't have an account ? ",
                      style: AppTextStyle.fontStyleGrey16400w.copyWith(color: Colors.black),
                    ),
                    TextSpan(
                        text: "Sign Up  ",
                        style: AppTextStyle.fontStyleGrey16400w.copyWith(color: ColorApp.mainApp)
                    ),

                  ]
              )
                   ),
         ),
      ],
    );
  }
}
