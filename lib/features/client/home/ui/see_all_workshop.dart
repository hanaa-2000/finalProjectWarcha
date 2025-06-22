import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_empty_list.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/client/home/data/workshop_model.dart';
import 'package:warcha_final_progect/features/client/home/logic/workshops_cubit.dart';
import 'package:warcha_final_progect/features/client/home/ui/warcha_screen.dart';
import 'package:warcha_final_progect/main.dart';

class SeeAllWorkshop extends StatefulWidget {
  const SeeAllWorkshop({super.key});

  @override
  State<SeeAllWorkshop> createState() => _SeeAllWorkshopState();
}

class _SeeAllWorkshopState extends State<SeeAllWorkshop> {
 //  @override
 //  void initState() {
 //    super.initState();
 //    BlocProvider.of<WorkshopsCubit>(context).fetchAllWorkshops();
 //  }
 //
 // void didPopNext() {
 //    // 📌 يتم استدعاؤها لما ترجع للشاشة دي
 //    BlocProvider.of<WorkshopsCubit>(context).fetchAllWorkshops();
 //  }
 //  @override
 //  void didChangeDependencies() {
 //    BlocProvider.of<WorkshopsCubit>(context).fetchAllWorkshops();
 //    super.didChangeDependencies();
 //  }
  late VoidCallback _removeWillPopCallback;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    BlocProvider.of<WorkshopsCubit>(context).fetchAllWorkshops();

    // إضافة الكولباك وإبقاء مرجع لإزالته لاحقاً
    final route = ModalRoute.of(context);
    if (route != null) {
      route.addScopedWillPopCallback(_Willpop);
      _removeWillPopCallback = () => route.removeScopedWillPopCallback(_Willpop);
    }

    // SharedPrefHelper.getInt("userId").then((id) {
    //   if (mounted) {
    //     setState(() {
    //       userId = id;
    //     });
    //   }
    // });
  }

  Future<bool> _Willpop() async {
    // هنا تتأكد أنك تتعامل فقط لما يكون mounted
    if (mounted) {
      BlocProvider.of<WorkshopsCubit>(context).fetchAllWorkshops();
    }
    return true;
  }

  @override
  void dispose() {
    _removeWillPopCallback(); // لازم تحذف الكولباك
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "All Instant Maintenance ",
          style: AppTextStyle.font18BlackW600,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
        child: BlocConsumer<WorkshopsCubit, WorkshopsState>(
          listenWhen:
              (previous, current) =>
                  current is WorkshopsRefresh && current is GetAllWorkshopsSuccess,
          listener: (context, state) {
            if (state is GetAllWorkshopsSuccess) {
              BlocProvider.of<WorkshopsCubit>(context).fetchWorkshops();
            }
          },
          builder: (context, state) {
            if (state is GetAllWorkshopsLoading) {
              return CustomLoadingWidget();
            } else if (state is GetAllWorkshopsSuccess) {
              final list = state.list;

              if (list.isEmpty) {
                return const CustomEmptyList(
                  title: "No data available at the moment.",
                );
              }

              return ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),

                itemBuilder: (context, index) {
                  print("${list[index].isBooked}");
                  // if(isWorkshopOpen(list[index].startTime! ,list[index].endTime!)){

                  return buildCard(context, list[index]);
                  //  }
                  // else{
                  //   return CustomEmptyList(title: "No Workshop Opened Now");
                  //  }
                },
              );
            } else if (state is GetAllWorkshopsError) {
              return CustomErrorWidget(errorMessage: state.errMsg);
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // void showCustomBottomSheet(BuildContext context) {
  buildCard(context, WorkshopModel list) {
    return GestureDetector(
      onTap: () {
        print("🔍 Going to WarchaScreen with:");
        print("📌 name = ${list.name}");
        print("📌 location = ${list.location}");
        print("📌 lat = ${list.latitude}, long = ${list.longitude}");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WarchaScreen(list: list)),
        );
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

                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(16.r),
                //   image: list.image != null && list.image!.isNotEmpty
                //       ? DecorationImage(
                //     image: CachedNetworkImageProvider(list.image!),
                //     fit: BoxFit.cover,
                //   )
                //       : const DecorationImage(
                //     image: AssetImage('assets/images/placeholder.png'),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                        imageUrl: list.image ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder:
                            (context, url) => Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image,
                                size: 48.r,
                                color: ColorApp.greyColor,
                              ),
                            ),
                        // يمكنك إضافة تأثير الانتقال للصور بسرعة
                        fadeInDuration: const Duration(milliseconds: 300),
                        // ← هنا الانتقال
                        fadeOutDuration: Duration(milliseconds: 300),
                      )
                      .animate()
                      .scale(duration: 200.ms)
                      .scaleXY(delay: 200.ms, duration: 400.ms)
                      .then(delay: 200.ms)
                      .blurXY(begin: 10, end: 0),
                ),
              ),
            ),

            SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(list.name, style: AppTextStyle.font16BlackW700),
                      IconButton(
                        onPressed: () async {
                          if (list.latitude != null && list.longitude != null) {
                            final Uri googleMapsUrl = Uri.parse(
                              "https://www.google.com/maps/search/?api=1&query=${list.latitude},${list.longitude}",
                            );
                            log(list.latitude.toString());
                            log(list.longitude.toString());
                            await launchUrl(
                              googleMapsUrl,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              confirmBtnText: "OK",
                              title: "No site found",
                              text:
                                  "It appears this is the customer's first visit. Take a picture of the device to record the location.",
                            );
                          }
                        },
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () async {
                      if (list.phone != null) {
                        final String phone = list.phone;
                        final Uri callUrl = Uri.parse("tel:$phone");

                        if (await canLaunchUrl(callUrl)) {
                          await launchUrl(callUrl);
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: "fail",
                            text:
                                "Call could not be started, make sure your phone supports calling",
                            confirmBtnText: "OK",
                          );
                        }
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: "No phone number",
                          text:
                              "It appears that this customer does not have a registered phone number.",
                          confirmBtnText: "OK",
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.local_phone_outlined, color: Colors.black),
                        SizedBox(width: 6.w),
                        Container(
                          height: 25.h,
                          width: 1.w,
                          color: ColorApp.greyColor,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          list.phone,
                          style: AppTextStyle.fontStyleGrey14400w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  RatingBarIndicator(
                    rating: 2.75,
                    itemSize: 25.r,
                    itemBuilder:
                        (context, index) =>
                            Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    direction: Axis.horizontal,
                  ),
                  // RatingBar.builder(
                  //   initialRating: 3,
                  //   minRating: 1,
                  //   itemSize: 25.r,
                  //   direction: Axis.horizontal,
                  //   allowHalfRating: true,
                  //   itemCount: 5,
                  //   maxRating: 5,
                  //   itemPadding:
                  //       EdgeInsets.symmetric(vertical: 2.h, horizontal: 0.w),
                  //   itemBuilder: (context, _) => Icon(
                  //     Icons.star,
                  //     size: 16.r,
                  //     color: Colors.amber,
                  //   ),
                  //   onRatingUpdate: (rating) {
                  //     print(rating);
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
