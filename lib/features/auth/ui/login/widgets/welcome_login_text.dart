import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class WelcomeLoginText  extends StatelessWidget {
  const WelcomeLoginText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text("Welcome Back" , style: AppTextStyle.fontStyleBlue24700w,),
        SizedBox(height: 16.h,),
        Text("We're excited to have you back, can't wait to see what you've been up to since you last logged in.", style: AppTextStyle.fontStyleGrey16400w,)
        
      ],
    );
  }
}
