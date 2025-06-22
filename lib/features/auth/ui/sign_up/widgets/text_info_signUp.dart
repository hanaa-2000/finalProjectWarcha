import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/extension.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class TextInfoSignup  extends StatelessWidget {
  const TextInfoSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // RichText(
        //     textAlign: TextAlign.center,
        //     textScaleFactor:1.03,
        //     text:TextSpan(
        //
        //         children: [
        //           TextSpan(
        //             text: "By logging, you agree to our ",
        //             style: AppTextStyle.fontStyleGrey14400w,
        //           ),
        //           TextSpan(
        //               text: "Terms & Conditions ",
        //               style: AppTextStyle.fontStyleGrey14400w.copyWith(color: Colors.black)
        //           ),
        //           TextSpan(
        //               text: "and ",
        //               style:AppTextStyle.fontStyleGrey14400w
        //
        //           ),
        //           TextSpan(
        //               text: "PrivacyPolicy.",
        //               style:AppTextStyle.fontStyleGrey14400w.copyWith(color: Colors.black)
        //           ),
        //         ]
        //     )
        // ),
        SizedBox(height:16.h,),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              context.pushNamed(Routes.login);
            },
            child: RichText(
                textAlign: TextAlign.center,
                text:TextSpan(

                    children: [
                      TextSpan(
                        text: "Already have an account yet? ",
                        style: AppTextStyle.fontStyleGrey16400w.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                          text: "Login ",
                          style: AppTextStyle.fontStyleGrey16400w.copyWith(color: ColorApp.mainApp)
                      ),

                    ]
                )
            ),
          ),
        ),
      ],
    );
  }
}
