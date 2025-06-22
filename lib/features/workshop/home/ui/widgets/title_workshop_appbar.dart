import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';

class TitleWorkshopAppbar  extends StatefulWidget {
  const TitleWorkshopAppbar({super.key});

  @override
  State<TitleWorkshopAppbar> createState() => _TitleWorkshopAppbarState();
}

class _TitleWorkshopAppbarState extends State<TitleWorkshopAppbar> {
  @override
  void initState() {
    _loadItem();
    setState(() {

    });
    super.initState();
  }
  String userName='';
  _loadItem(){
  userName=  SharedPrefHelper.getString("name");
  setState(() {

  });

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi, ${userName}!",style: TextStyle(color: Colors.black , fontSize: 21.sp,fontWeight: FontWeight.w700),),
                Text("How Are you Today?",style: TextStyle(color: ColorApp.greyColor , fontSize: 14.sp,fontWeight: FontWeight.w400),),

              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                color: Color(0xffF5F5F5)
              ),
              child: IconButton(onPressed: () {
                Scaffold.of(context).openEndDrawer();
              }, icon: Icon(Icons.menu , color: Colors.black,size:30.r,)),
            )
          ],
        ),

      ],
    );
  }

  Widget buildDrawerButton(){
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [

        ],
      ),

    ) ;
    // Container(
    //
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(12.r),
    //   color: Colors.white,
    //   ),
    //   child: Column(
    //     children: [
    //       Text(data)
    //     ],
    //   ),
    //
    // ),
  }
}
