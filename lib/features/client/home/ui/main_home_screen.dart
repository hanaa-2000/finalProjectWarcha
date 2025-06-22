import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/notification/push_notification_service.dart';
import 'package:warcha_final_progect/features/client/examin/ui/examin_screen.dart';
import 'package:warcha_final_progect/features/client/favorite/ui/favorite_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/home_client_screen.dart';
import 'package:warcha_final_progect/features/client/profile/ui/profile_screen.dart';
import 'package:warcha_final_progect/features/client/store/ui/store_client_screen.dart';

class MainHomeClientScreen  extends StatefulWidget {
  const MainHomeClientScreen({super.key});

  @override
  State<MainHomeClientScreen> createState() => _MainHomeClientScreenState();
}

class _MainHomeClientScreenState extends State<MainHomeClientScreen> {
  int _currentIndex = 0;

  // قائمة الصفحات
  final List<Widget> _pages = [
    HomeClientScreen(),
    ExamineScreen(),
    StoreClientScreen(),
    FavoriteScreen(),
  ];

  // قائمة الأيقونات
  final List<Widget> _icons = [

   //  FontAwesomeIcons.tools,
   // // FontAwesomeIcons.carOn,
   //  Icons.electric_car_rounded,
   //  CupertinoIcons.cart_fill,
  ];
@override
  void initState() {
  PushNotificationService().setupOnMessageListener();
  takeToken();
    super.initState();
  }
  takeToken()async{
  final token = await PushNotificationService().getDeviceToken();
  final fcmToken = await SharedPrefHelper.setString("fcm", token!);
  print("📱 FCM Token: $token");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor:Colors.white,
        //Colors.grey.shade200,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blueAccent,
        animationDuration: Duration(milliseconds: 300),
        height:60.h,
          items:[
            SvgPicture.asset("assets/images/maintenance.svg",width: 40,height: 40,colorFilter: ColorFilter.mode(Colors.white,BlendMode.srcIn)),
            SvgPicture.asset("assets/images/car_search.svg",width: 40,height: 40,colorFilter: ColorFilter.mode(Colors.white,BlendMode.srcIn)),

            SvgPicture.asset("assets/images/car_accssec.svg",width: 40,height: 40,colorFilter: ColorFilter.mode(Colors.white,BlendMode.srcIn),),
          Icon(Icons.favorite ,color: Colors.white, ),
         // Image.asset("assets/images/image_profile.png",width: 40,height: 40,),
          ],

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
