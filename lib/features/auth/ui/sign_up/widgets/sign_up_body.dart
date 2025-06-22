import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/features/auth/ui/icon_widget.dart';
import 'package:warcha_final_progect/features/auth/ui/sign_up/widgets/build_row_signUp.dart';
import 'package:warcha_final_progect/features/auth/ui/sign_up/widgets/signUp_text_field.dart';
import 'package:warcha_final_progect/features/auth/ui/sign_up/widgets/text_info_signUp.dart';
import 'package:warcha_final_progect/features/auth/ui/sign_up/widgets/welcome_signUp_text.dart';

class SignUpBody extends  StatelessWidget {
  const SignUpBody({super.key,});


  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:EdgeInsets.symmetric(horizontal: 25.w ,vertical: 32.h) ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeSignupText(title: "Create Account",desc: "Sign up now and start exploring all that our app has to offer. We're excited to welcome you to our community!",),
                SizedBox(height: 48.h,),
                SignupTextField(),
                //SizedBox(height:48.h,),
               // BuildRowSignup(),
                SizedBox(height: 24.h,),
               // IconWidget(),
                SizedBox(height: 24.h,),
                TextInfoSignup(),
          
              ],
            ),
          ),
        ),);
  }
}
