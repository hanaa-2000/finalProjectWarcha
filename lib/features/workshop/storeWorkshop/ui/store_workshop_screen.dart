import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/core/widgets/drawer_body.dart';
import 'package:warcha_final_progect/features/workshop/home/data/workshop_home_repo.dart';
import 'package:warcha_final_progect/features/workshop/home/logic/workshop_home_cubit.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/widgets/title_workshop_appbar.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/ui/widgets/tab_items_view_body.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/ui/widgets/tab_orders_view_body.dart';

class StoreWorkshopScreen extends StatefulWidget {
  const StoreWorkshopScreen({super.key});

  @override
  State<StoreWorkshopScreen> createState() => _StoreWorkshopScreenState();
}

class _StoreWorkshopScreenState extends State<StoreWorkshopScreen> {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SafeArea(
          child: Scaffold(
            endDrawer: BlocProvider(
              create: (context) => WorkshopHomeCubit(WorkshopHomeRepo())..getPeople()..loadSelectedNames(),
              child: Drawer(
                backgroundColor: Colors.white,
                child: DrawerBody(),
              ),
            ),

            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leadingWidth: 0.w,
              actions: [
                SizedBox.shrink()
              ],
              leading: SizedBox.shrink(),
              title: TitleWorkshopAppbar(),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(80.h),
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: TabBar(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.blue,
                    ),
                    dividerHeight: 0,
                    indicatorSize: TabBarIndicatorSize.label,
                    splashBorderRadius: BorderRadius.circular(16.r),
                    textScaler: TextScaler.linear(1),

                    indicatorColor: Colors.transparent,
                    tabs: [
                      Tab(child: Center(child: Text("Sent Orders"))),
                      Tab(child: Center(child: Text("Add Items"))),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(children: [
              TabOrdersViewBody(),
              TabItemsViewBody()
    ]),

          ),
        ),
      ),
    );
  }

}
