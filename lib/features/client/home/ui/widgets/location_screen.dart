import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';

class LocationScreen  extends StatelessWidget {
  const LocationScreen({super.key, required this.location, required this.langtiud, required this.latituid});
 final String location;
 final String langtiud;
 final String latituid;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children:[
        Text("Practice Place" , style: AppTextStyle.font16BlackW700,),
        SizedBox(height: 12.h,),
        Text(
         location == ''?"Not Fiend Location":
          location , style: AppTextStyle.fontStyleGrey14400w,),
        SizedBox(height: 12.h,),
        Text("Location Map" , style: AppTextStyle.font16BlackW700.copyWith(fontWeight: FontWeight.w500),),
        SizedBox(height: 12.h,) ,
      GestureDetector(
        onTap: () async{
          if (latituid != null &&
              langtiud != null) {
            final Uri googleMapsUrl = Uri.parse(
                "https://www.google.com/maps/search/?api=1&query=${latituid},${langtiud}");
            log(latituid.toString());
            log(langtiud.toString());
            await launchUrl(googleMapsUrl,
            mode: LaunchMode.externalApplication);
          } else {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                confirmBtnText: "OK",
                title: "No site found",
                text:
                "It appears this is the customer's first visit. Take a picture of the device to record the location.");
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Material(
           child: Image.asset("assets/images/Map.png" ,fit: BoxFit.cover,)),
        ),
      )

        



      ]
    );
  }
}
