import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/client/examin/ui/widgets/card_workshop_widget.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/title_appbar.dart';

class ExamineBody extends StatelessWidget {
  const ExamineBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w , vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAppbar(),
          SizedBox(height: 24.h,),
          Text("Inspection" , style: AppTextStyle.font18BlackW600,),
          Expanded(child: CardWorkshopWidget())

        ],
      ),
    ));
  }
}
