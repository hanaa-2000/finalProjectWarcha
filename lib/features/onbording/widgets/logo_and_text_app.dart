import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';


class LogoAndTextApp  extends StatelessWidget {
  const LogoAndTextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
         foregroundDecoration: BoxDecoration(
           gradient: LinearGradient(colors: [
             Colors.white,
             Colors.white.withOpacity(0.0),
           ],
           begin: Alignment.bottomCenter,
             end: Alignment.topCenter,
             stops: [0.14,0.4]
           ),
         ),
          child: Image.asset("assets/images/onboarding_image.png",),
        ),
        Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child:Text("Best Car Service Appointment App",style:AppTextStyle.fontStyleBlue32700w.copyWith(height: 1.4.h),textAlign: TextAlign.center,),


        ),
      ],
    );
  }
}
