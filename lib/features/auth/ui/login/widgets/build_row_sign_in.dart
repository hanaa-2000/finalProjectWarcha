import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class BuildRowSignIn  extends StatelessWidget {
  const BuildRowSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: ColorApp.greyColor,
            thickness: 1,
            indent: 30,
            endIndent: 10,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Or sign in with",
            style: AppTextStyle.fontStyleGrey14400w,
          ),
        ),
        Expanded(
          child: Divider(
            color: ColorApp.greyColor,
            thickness: 1,
            indent: 10,
            endIndent: 30,
          ),
        ),
      ],
    );
  }
}
