import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:warcha_final_progect/core/helper/spacing.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class CustomEmptyList extends StatelessWidget {
  final String title;
  const CustomEmptyList({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //const Spacer(),
          // SvgPicture.asset(
          //   "assets/images/no_data.svg",
          //   width: MediaQuery.sizeOf(context).width / 2,
          // ),
          Lottie.asset("assets/images/empty.json"),

          verticalSpace(32),
          Text(
            title,
            style: AppTextStyle.font18BlackW600,
          ),
       //   const Spacer()
        ],
      ),
    );
  }
}
