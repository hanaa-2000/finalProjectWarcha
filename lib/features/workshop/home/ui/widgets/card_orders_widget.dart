import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/features/client/home/data/appointment_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:warcha_final_progect/features/client/store/ui/widgets/chat_screen_workshop.dart';

class CardOrdersWidget  extends StatelessWidget {
  const CardOrdersWidget({super.key, required this.order});
 final AppointmentModel order;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        showBottomSheet(context,order);
      },
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 4.h,
          vertical: 16.w,
        ),
        margin: EdgeInsetsDirectional.symmetric(
          horizontal: 4.h,
          vertical: 12.w,
        ),
        width: MediaQuery.sizeOf(context).width,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: Color(0xffe9ecef)),
          ),
          color: Colors.white,
          shadows: const [
            BoxShadow(
              color: Color.fromARGB(255, 241, 244, 248),
              blurRadius: 3.0, // soften the shadow
              spreadRadius: 3.0, //extend the shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 120.h,
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/Image2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // ClipRRect(
            //
            //   borderRadius: BorderRadius.circular(12),
            //   child: CachedNetworkImage(
            //     imageUrl: order. ?? '',
            //     fit: BoxFit.cover,
            //     width: double.infinity,
            //     placeholder: (context, url) =>
            //         Container(
            //           alignment: Alignment.center,
            //           child: CircularProgressIndicator(color: Colors.blue,),
            //         ),
            //     errorWidget: (context, url, error) =>
            //         Container(
            //           color: Colors.grey[200],
            //           alignment: Alignment.center,
            //           child: Icon(Icons.image, size: 48.r,
            //             color: ColorApp.greyColor,),
            //         ),
            //     // يمكنك إضافة تأثير الانتقال للصور بسرعة
            //     fadeInDuration: const Duration(milliseconds: 300), // ← هنا الانتقال
            //     fadeOutDuration: Duration(milliseconds: 300),
            //
            //   ).animate()
            //       .scale(duration: 200.ms)
            //       .scaleXY(delay: 200.ms, duration: 400.ms)
            //       .then(delay: 200.ms)
            //       .blurXY(begin: 10, end: 0),
            // ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.clientName,
                    style: AppTextStyle.font16BlackW700,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                       order.carModel,
                        style: AppTextStyle.fontStyleGrey14400w,
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        height: 16.h,
                        width: 1.w,
                        color: ColorApp.greyColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        order.phone,
                        style: AppTextStyle.fontStyleGrey14400w,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                     IconButton(
                         onPressed: () async{
                           if (order.latitude != null &&
                               order.longtude != null) {
                             final Uri googleMapsUrl = Uri.parse(
                                 "https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longtude}");
                             log(order.latitude.toString());
                             log(order.longtude.toString());
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
                         icon: Icon(Icons.location_on_outlined)),
                      SizedBox(width: 6.w),
                      Container(
                        height: 16.h,
                        width: 1.w,
                        color: ColorApp.greyColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        order.address,
                        style: AppTextStyle.fontStyleGrey14400w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showBottomSheet(BuildContext context, AppointmentModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,

          initialChildSize: 0.8,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*.9,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal:6.w, vertical: 0.h),
                    child: Column(
                      children: [
                        Container(
                          width: 50.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: Colors.grey.shade200,
                          ),
                        ),
                        SizedBox(height: 16.h,),
                        Text("Information" , style: AppTextStyle.font18BlackW600,),
                        SizedBox(height: 16.h,),
                        Divider(color: Colors.grey.shade300,),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.grey[100],
                              child: IconButton(onPressed: ()async {
                                if (order.phone != null) {
                                  final String phone = order.phone;
                                  final Uri callUrl = Uri.parse("tel:$phone");

                                  if (await canLaunchUrl(callUrl)) {
                                await launchUrl(callUrl);
                                } else {
                                QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: "fail",
                                text: "Call could not be started, make sure your phone supports calling",
                                confirmBtnText: "OK",
                                );
                                }
                                } else {
                                QuickAlert.show(
                                context: context,
                                type: QuickAlertType.warning,
                                title: "No phone number",
                                text: "It appears that this customer does not have a registered phone number.",
                                confirmBtnText: "OK",
                                );
                                }
                              }, icon: Icon(Icons.phone_outlined ,color: Colors.blue,size: 32.r,)),
                            ),
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.grey[100],
                              child: IconButton(
                                  onPressed: () async{
                                    if (order.latitude != null &&
                                        order.longtude != null) {
                                      final Uri googleMapsUrl = Uri.parse(
                                          "https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longtude}");
                                      log(order.latitude.toString());
                                      log(order.longtude.toString());
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
                                  }
                              , icon: Icon(Icons.location_on ,color: Colors.blue,size: 30.r,)),
                            ),
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.grey[100],
                              child: IconButton(onPressed: () {
                                final types.User workshopUser = types.User(
                                  id: order.userId, // نفس الـ uid الخاص بالورشة
                                  firstName: order.clientName ,
                                );
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreenWorkshop(otherUser: workshopUser,),));
                              }, icon: Icon(Icons.message ,color: Colors.blue,size: 28.r,)),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(height: 12.h),
                        Container(
                          height:55.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius:10.r,
                                  color: Colors.grey.shade200,
                                  blurStyle: BlurStyle.solid,
                                  spreadRadius: .5

                              )
                            ],
                          ),
                          child: Center(
                            child: Text(order.address , style: AppTextStyle.fontStyleGrey16400w.copyWith(color: ColorApp.greyColor,fontWeight: FontWeight.w600)),
                          ),
                        ) ,
                        SizedBox(height: 12.h),
                        Container(
                          height:55.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius:10.r,
                                  color: Colors.grey.shade200,
                                  blurStyle: BlurStyle.solid,
                                  spreadRadius: .5

                              )
                            ],
                          ),
                          child: Center(
                            child: Text(order.carBrand , style: AppTextStyle.fontStyleGrey16400w.copyWith(color: ColorApp.greyColor,fontWeight: FontWeight.w600)),
                          ),
                        ) ,
                        SizedBox(height: 12.h),
                        Container(
                          height:55.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius:10.r,
                                  color: Colors.grey.shade200,
                                  blurStyle: BlurStyle.solid,
                                  spreadRadius: .5

                              )
                            ],
                          ),
                          child: Center(
                            child: Text(order.carModel , style: AppTextStyle.fontStyleGrey16400w.copyWith(color: ColorApp.greyColor,fontWeight: FontWeight.w600)),
                          ),
                        ) ,
                        SizedBox(height: 12.h),
                        Container(
                          height:55.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                          ),
                          child: Center(
                            child: Text(order.phone , style: AppTextStyle.fontStyleGrey16400w.copyWith(color: ColorApp.greyColor,fontWeight: FontWeight.w600)),
                          ),
                        ) ,
                        SizedBox(height: 12.h),
                        Container(
                          height:120.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius:10.r,
                                  color: Colors.grey.shade200,
                                  blurStyle: BlurStyle.solid,
                                  spreadRadius: .5

                              )
                            ],
                          ),
                          child: Center(
                            child: Text(order.problem ,textAlign: TextAlign.center, style: AppTextStyle.fontLightGrey14500w.copyWith(color: ColorApp.greyColor,fontWeight: FontWeight.w600)),
                          ),
                        ) ,
                        SizedBox(height: MediaQuery.of(context).size.height/9.8),
                        CostumeButtonApp(
                          title: "Done",
                        ),
                        SizedBox(height:32.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
