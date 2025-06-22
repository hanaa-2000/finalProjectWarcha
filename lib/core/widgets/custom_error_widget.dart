import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  const CustomErrorWidget({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/error_internet.png",
            width: 120.w,
          ),
          SizedBox(height: 16.w,),
          Text(
            errorMessage,
            style: AppTextStyle.font18BlackW600,
            softWrap: true,
            textAlign:TextAlign.center,
          ),
        ],
      ),
    );
  }
}
