import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class WelcomeSignupText  extends StatelessWidget {
  const WelcomeSignupText({super.key, required this.title, required this.desc});
final String title;
final String desc;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(title , style: AppTextStyle.fontStyleBlue24700w,),
        SizedBox(height: 16.h,),
        Text(desc, style: AppTextStyle.fontStyleGrey16400w,)

      ],
    );
  }
}
