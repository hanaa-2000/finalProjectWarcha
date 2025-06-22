import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class RowTextTitle  extends StatelessWidget {
  const RowTextTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Instant Maintenance",style: AppTextStyle.font18BlackW600, ),
        Text("See All" , style: AppTextStyle.fontStyleBlue24700w.copyWith(fontSize: 18.sp),),

      ],
    );
  }
}
