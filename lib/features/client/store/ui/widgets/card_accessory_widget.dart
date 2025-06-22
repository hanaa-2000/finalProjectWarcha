import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
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
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_empty_list.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/client/store/data/accessories_model.dart';
import 'package:warcha_final_progect/features/client/store/logic/stor_workshop_cubit.dart';
import 'package:warcha_final_progect/features/client/store/payment/widgets/payment_botoom_sheet.dart';
import 'package:warcha_final_progect/features/client/store/ui/widgets/card_accessory_widget.dart';
import 'package:warcha_final_progect/features/client/store/ui/widgets/chat_screen_workshop.dart';

class CardAccessoryWidget  extends StatefulWidget {
  const CardAccessoryWidget({super.key});

  @override
  State<CardAccessoryWidget> createState() => _CardAccessoryWidgetState();
}

class _CardAccessoryWidgetState extends State<CardAccessoryWidget> {
  // @override
  // void initState() {
  //   BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();
  //   super.initState();
  // }
  late VoidCallback _removeWillPopCallback;
  String productId='';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();
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
  double selectedRating = 3.0;

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("اختر التقييم"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: selectedRating,
                minRating: 1,
                maxRating: 5,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.r,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    selectedRating = rating;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                "التقييم: ${selectedRating.toStringAsFixed(1)}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _submitReview();
              },
              child: const Text("تأكيد"),
            ),
          ],
        );
      },
    );
  }

  void _submitReview() {

    context.read<StorWorkshopCubit>().addReview(
      productId: productId,
      rating: selectedRating,
    );

    selectedRating = 3.0;
  }
  Future<bool> _Willpop() async {
    // هنا تتأكد أنك تتعامل فقط لما يكون mounted
    if (mounted) {
      BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StorWorkshopCubit, StorWorkshopState>(
  listener: (context, state) {
    if(state is GetAccessoriesSuccess){
   //   BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();
    }
    if(state is RefreshData){
    //  BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();
    }
    if(state is ProductBookingSuccess){
      //Navigator.of(context).pop();
      BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();
    }
  },
  builder: (context, state) {
    if(state is GetAccessoriesLoading){
      return CustomLoadingWidget();
    }
    else if(state is GetAccessoriesSuccess){
      final list = state.list;

      if(list.isEmpty){
        return CustomEmptyList(title: "No data available at the moment.");
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {

          return buildCardItem(context,list[index]);
        },

      );
    }
    else if(state is GetAccessoriesFailure){
      return CustomErrorWidget(errorMessage: state.errorMsg);
    }
    return SizedBox.shrink();

  },
);
  }

  void showDraggableBottomSheet(BuildContext context, AccessoriesModel list) {
    print("${list.workshopName+list.workshopId}");
    final customerId = FirebaseAuth.instance.currentUser?.uid;

    bool isBooked = list.bookedBy?.contains(FirebaseAuth.instance.currentUser?.uid) ?? false;

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

          initialChildSize: 0.6,
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
                        Text("Details" , style: AppTextStyle.font18BlackW600,),
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
                              child: IconButton(onPressed: () async{
                                if (list.latitude != null &&
                                    list.longitude != null) {
                                  final Uri googleMapsUrl = Uri.parse(
                                      "https://www.google.com/maps/search/?api=1&query=${list.latitude},${list.longitude}");
                                  log(list.latitude.toString());
                                  log(list.longitude.toString());
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
                              }, icon: Icon(Icons.location_on ,color: Colors.blue,size: 30.r,)),
                            ),
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.grey[100],
                              child: IconButton(onPressed: () {
                                final types.User workshopUser = types.User(
                                  id:list.workshopId, // نفس الـ uid الخاص بالورشة
                                  firstName: list.workshopName ,
                                );
                                Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreenWorkshop(otherUser: workshopUser,),));

                              }, icon: Icon(Icons.message ,color: Colors.blue,size: 28.r,)),
                            ),
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.grey[100],
                              child: IconButton(onPressed: () {
                                _showRatingDialog();
                              }, icon: Icon(Icons.star ,color: Colors.yellow,size: 28.r,)),
                            ),
                          ],
                        ),
                        SizedBox(height:48.h),
                        Container(
                          height: 65.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                          ),
                          child: Center(
                            child: Text(list.companyName , style: AppTextStyle.font18BlackW600.copyWith(color: ColorApp.greyColor)),
                          ),
                        ) ,
                        SizedBox(height:18.h),
                        Container(
                          height: 65.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                          ),
                          child: Center(child: Text(list.specifications , style: AppTextStyle.fontStyleGrey14400w.copyWith(fontWeight: FontWeight.w500))),
                        ) ,
                        SizedBox(height:18.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 65.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: ColorApp.fieldGrey,
                                  border: Border.all(color: ColorApp.greyLight),
                                ),
                                child: Center(child: Text(list.countryManufacture , style: AppTextStyle.fontStyleGrey14400w.copyWith(fontWeight: FontWeight.w500))),
                              ),
                            ),
                            SizedBox(width: 12.w,),
                            Expanded(
                              child: Container(
                                height: 65.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: ColorApp.fieldGrey,
                                  border: Border.all(color: ColorApp.greyLight),
                                ),
                                child: Center(child: Text(list.yearManufacture , style: AppTextStyle.fontStyleGrey14400w.copyWith(fontWeight: FontWeight.w500))),
                              ),
                            ),
                          ],
                        ) ,
                        SizedBox(height:24.h),
                        Container(
                          height: 65.h,
                          width:200.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                          ),
                          child: Center(child: Text("${list.price} EGP" , style: AppTextStyle.fontStyleBlue24700w.copyWith(fontSize: 16.sp))),
                        ) ,
                        SizedBox(height: MediaQuery.of(context).size.height/9.5),
                        CostumeButtonApp(
                          onPressed: () {
                            setState(() {
                              productId = list.id;
                            });
                            // showModalBottomSheet(
                            //   context: context,
                            //   backgroundColor: Colors.white,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(16),
                            //   ),
                            //   builder:(context) => PaymentBottomSheet(price:3000,),);
                            if(isBooked){
                              BlocProvider.of<StorWorkshopCubit>(context).cancelBooking(list.id).then((value) {

                                BlocProvider.of<StorWorkshopCubit>(context).refreshData();
                                Navigator.pop(context);

                              },);
                            }else{
                              BlocProvider.of<StorWorkshopCubit>(context).bookProduct(list,  list.id).then((value , ) {

                                BlocProvider.of<StorWorkshopCubit>(context).refreshData();
                                Navigator.pop(context);

                              },);

                            }


                          },
                          title: isBooked ?"Cancel":"Booking",
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

  buildCardItem(context,AccessoriesModel list){
    return GestureDetector(
      onTap: () {
        showDraggableBottomSheet(context,list) ;
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

                child:
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: list.image ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(color: Colors.blue,),
                        ),
                    errorWidget: (context, url, error) =>
                        Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Icon(Icons.image, size: 48.r,
                            color: ColorApp.greyColor,),
                        ),
                    // يمكنك إضافة تأثير الانتقال للصور بسرعة
                    fadeInDuration: const Duration(milliseconds: 300), // ← هنا الانتقال
                    fadeOutDuration: Duration(milliseconds: 300),

                  ).animate()
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
                  Text(
                    list.companyName,
                    style: AppTextStyle.font16BlackW700,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        list.countryManufacture,
                        style: AppTextStyle.fontStyleGrey14400w,
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        height: 25.h,
                        width: 1.w,
                        color: ColorApp.greyColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        list.yearManufacture,
                        style: AppTextStyle.fontStyleGrey14400w,
                      ),
                    ],
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

