import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/onbording/widgets/get_started_button.dart';
import 'package:warcha_final_progect/features/onbording/widgets/logo_and_text_app.dart';
class OnboardingScreen  extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:4.w , vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image.asset("assets/images/logo.png" , width: 150.w , height:120.h,),
              LogoAndTextApp(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    children: [
                      Text("Manage and schedule all of your car service appointments easily with Warcha+ to get a new experience.",style: AppTextStyle.fontStyleGrey14400w,textAlign: TextAlign.center,),
                      SizedBox(height: 30.h,),
                      GetStartedButton(),
                      SizedBox(height: 40.h,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),


    );
  }
}
