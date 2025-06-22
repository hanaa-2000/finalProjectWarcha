import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset("assets/images/loading_animation.json"),
    ) ;

      Center(
        child: LoadingAnimationWidget.staggeredDotsWave(

      // leftDotColor: ColorApp.greyColor,
      // rightDotColor: ColorApp.mainApp,
     color: ColorApp.mainApp,
      size: 80.r,
    ));
  }
}
