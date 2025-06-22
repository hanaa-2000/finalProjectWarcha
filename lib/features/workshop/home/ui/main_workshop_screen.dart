import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/notification/push_notification_service.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/features/client/profile/ui/profile_screen.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/home_workshop_screen.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/widgets/title_workshop_appbar.dart';
import 'package:warcha_final_progect/features/workshop/profile/ui/profile_workshop_screen.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/ui/store_workshop_screen.dart';

class MainWorkshopScreen  extends StatefulWidget {
  const MainWorkshopScreen({super.key});

  @override
  State<MainWorkshopScreen> createState() => _MainWorkshopScreenState();
}

class _MainWorkshopScreenState extends State<MainWorkshopScreen> {
  
    int _currentIndex = 0;

    // قائمة الصفحات
    final List<Widget> _pages = [
      HomeWorkshopScreen(),
      StoreWorkshopScreen(),
      ProfileWorkshopScreen(),


    ];
@override
  void initState() {
    super.initState();


  }
    // قائمة الأيقونات
    final List<Widget> _icons = [

      //  FontAwesomeIcons.tools,
      // // FontAwesomeIcons.carOn,
      //  Icons.electric_car_rounded,
      //  CupertinoIcons.cart_fill,
    ];
// takeToken()async{
//   final token = await PushNotificationService().getDeviceToken();
//   final fcmToken = await SharedPrefHelper.setString("fcm", token!);
//   print("📱 FCM Token: $token");
// }
    @override
    Widget build(BuildContext context) {
      return Scaffold(

        // endDrawer: Drawer(
        //   backgroundColor: Colors.white,
        //   child: Column(
        //     children: [
        //       Expanded(
        //         child: SingleChildScrollView(
        //           child: Column(
        //             children: [
        //               SizedBox(
        //                 height: 60.h,
        //               ),
        //               Text("Available", style: AppTextStyle.font18BlackW600),
        //               SizedBox(
        //                 height: 32.h,
        //               ),
        //               Container(
        //                 height:1.h,
        //                 width: 250.w,
        //                 color: Colors.grey,
        //               ),
        //               SizedBox(
        //                 height: 32.h,
        //               ),
        //               Container(
        //                 padding: EdgeInsets.symmetric(horizontal: 24.w , vertical: 24.h),
        //                 margin: EdgeInsets.symmetric(horizontal: 24.w , vertical: 8.h),
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(16.r),
        //                   color: Colors.blue,
        //
        //                 ) ,
        //                 child: Center(
        //                   child: Text("Mechanic",style: AppTextStyle.font16WhiteMedium.copyWith(fontWeight: FontWeight.bold),),
        //                 ),
        //               ),
        //               Container(
        //                 padding: EdgeInsets.symmetric(horizontal: 24.w , vertical: 24.h),
        //                 margin: EdgeInsets.symmetric(horizontal: 24.w , vertical: 8.h),
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(16.r),
        //                   color: Colors.blue,
        //
        //                 ) ,
        //                 child: Center(
        //                   child: Text("Bodywork Specialist",style: AppTextStyle.font16WhiteMedium.copyWith(fontWeight: FontWeight.bold),),
        //                 ),
        //               ),
        //               Container(
        //                 padding: EdgeInsets.symmetric(horizontal: 24.w , vertical: 24.h),
        //                 margin: EdgeInsets.symmetric(horizontal: 24.w , vertical: 8.h),
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(16.r),
        //                   color: Colors.blue,
        //
        //                 ) ,
        //                 child: Center(
        //                   child: Text("Chassis Technician",style: AppTextStyle.font16WhiteMedium.copyWith(fontWeight: FontWeight.bold),),
        //                 ),
        //               ),
        //               Container(
        //                 padding: EdgeInsets.symmetric(horizontal: 24.w , vertical: 24.h),
        //                 margin: EdgeInsets.symmetric(horizontal: 24.w , vertical: 8.h),
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(16.r),
        //                   color: Colors.blue,
        //
        //                 ) ,
        //                 child: Center(
        //                   child: Text("Auto Electrician",style: AppTextStyle.font16WhiteMedium.copyWith(fontWeight: FontWeight.bold),),
        //                 ),
        //               ),
        //               Container(
        //                 padding: EdgeInsets.symmetric(horizontal: 24.w , vertical: 24.h),
        //                 margin: EdgeInsets.symmetric(horizontal: 24.w , vertical: 8.h),
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(16.r),
        //                   color: Colors.blue,
        //
        //                 ) ,
        //                 child: Center(
        //                   child: Text("Auto Body Painter",style: AppTextStyle.font16WhiteMedium.copyWith(fontWeight: FontWeight.bold),),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(height: 24.h,),
        //       Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
        //         child: Align(
        //           alignment: Alignment.bottomRight,
        //           child: FloatingActionButton(
        //
        //             shape: CircleBorder(),
        //             onPressed: () {
        //               showDetailsDialog(context);
        //             },
        //             backgroundColor: Colors.blue,
        //             child: Icon(Icons.add , color: Colors.white,),
        //           ),
        //         ),
        //       ),
        //       SizedBox(height: 24.h,),
        //     ],
        //   ),
        // ),

        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leadingWidth: 0.w,
        //   actions: [
        //     SizedBox.shrink()
        //   ],
        //   leading: SizedBox.shrink(),
        //   title: TitleWorkshopAppbar(),
        //
        // ),

        body: _pages[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor:Colors.white,
          //Colors.grey.shade200,
          color: Colors.blue,
          buttonBackgroundColor: Colors.blueAccent,
          animationDuration: Duration(milliseconds: 300),
          height:60.h,
          items:[
            Icon(Icons.assignment_rounded,color: Colors.white,),
            Icon(Icons.shopping_cart_rounded,color: Colors.white,),
            Icon(Icons.account_circle,color: Colors.white,),

               ],

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    }
    void showDetailsDialog(context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Addition",
              style: AppTextStyle.fontStyleGrey12400w.copyWith(fontSize: 24.sp ,fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add other mechanical craftsmen?",
                  style: AppTextStyle.font16BlackW700.copyWith(fontWeight: FontWeight.w400),
                  // textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 12.h,
                ),
                AppTextFormField(labelText: "Added....", validator: (p0) {

                },),

              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [

              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorApp.mainApp,
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 20.w),
                ),
                onPressed: () {
                  Navigator.pop(context);

                },
                child: Text(
                  "Done",
                  style: AppTextStyle.font18BlackW600.copyWith(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
  }
