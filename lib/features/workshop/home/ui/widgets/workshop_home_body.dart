import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/widgets/list_orders_widget.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/widgets/title_workshop_appbar.dart';

class WorkshopHomeBody  extends StatelessWidget {
  const WorkshopHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w ,vertical: 12.h),
      child: Column(
        children: [
          TitleWorkshopAppbar(),
          SizedBox(height: 24.h,),
          ListOrdersWidget(),

        ],
      ),
    )) ;
  }
}
