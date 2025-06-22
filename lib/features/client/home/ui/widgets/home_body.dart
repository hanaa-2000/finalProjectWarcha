import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/client/home/ui/see_all_workshop.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/card_warcha_item.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/row_text_title.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/title_appbar.dart';

class HomeClientBody extends StatefulWidget {
  const HomeClientBody({super.key});

  @override
  State<HomeClientBody> createState() => _HomeClientBodyState();
}

class _HomeClientBodyState extends State<HomeClientBody> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w , vertical: 30.h),
        child: Column(children: [
          TitleAppbar(),
          SizedBox(height: 24.h,),
        //  RowTextTitle(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Instant Maintenance",style: AppTextStyle.font18BlackW600, ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SeeAllWorkshop(),));
                },
                child: Text("See All" , style: AppTextStyle.fontStyleBlue24700w.copyWith(fontSize: 18.sp),)),

          ],
        ),
          SizedBox(height: 24.h,),
          Expanded(child: CardWarchaItem()),
            ]),
      ),);
  }
}
