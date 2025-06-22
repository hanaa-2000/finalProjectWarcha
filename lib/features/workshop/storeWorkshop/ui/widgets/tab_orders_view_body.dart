import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:warcha_final_progect/features/workshop/storeWorkshop/data/product_model.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/logic/store_cubit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:warcha_final_progect/features/workshop/storeWorkshop/ui/chat_client_screen_workshop.dart';

class TabOrdersViewBody extends StatefulWidget {
  const TabOrdersViewBody({super.key});

  @override
  State<TabOrdersViewBody> createState() => _TabOrdersViewBodyState();
}

class _TabOrdersViewBodyState extends State<TabOrdersViewBody> {
  // String userId = '';
  // String userName = '';
  @override
  void initState() {
    BlocProvider.of<StoreCubit>(context).fetchProductsForWorkshop();
    // _loadData();
    setState(() {});
    super.initState();
  }

  //
  // _loadData()async{
  //   userName= await SharedPrefHelper.getString("name");
  //   userId =await SharedPrefHelper.getString("id");
  //   setState(() {
  //
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ProductBookingLoading) {
          return CustomLoadingWidget();
        } else if (state is ProductBookingError) {
          return CustomErrorWidget(errorMessage: state.errorMessage);
        } else if (state is ProductBookingSuccess) {
          final list = state.bookings;
          if (list.isEmpty) {
            return CustomEmptyList(title: "No Products Booking");
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return buildCardItemsOrder(context, list[index]);
                  },
                ),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  buildCardItemsOrder(context, ProductModel list) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(context, list);
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
                    image: AssetImage("assets/images/cotsh.png"),
                    fit: BoxFit.cover,
                  ),
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
                    list.bookingModel![0].clientName,
                    style: AppTextStyle.font16BlackW700,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        list.companyName,
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
                        list.yearManufacture,
                        style: AppTextStyle.fontStyleGrey14400w,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (list.bookingModel![0].clientPhone != null) {
                            final String phone =
                                list.bookingModel![0].clientPhone;
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
                        child: Icon(Icons.phone),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        height: 16.h,
                        width: 1.w,
                        color: ColorApp.greyColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        list.bookingModel![0].clientPhone,
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

  void showBottomSheet(BuildContext context, ProductModel list) {
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
                  width: MediaQuery.of(context).size.width * .9,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 0.h,
                    ),
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
                        SizedBox(height: 16.h),
                        Text(
                          "Information",
                          style: AppTextStyle.font18BlackW600,
                        ),
                        SizedBox(height: 16.h),
                        Divider(color: Colors.grey.shade300),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.grey[100],
                              child: IconButton(
                                onPressed: () async {
                                  if (list.bookingModel![0].clientPhone !=
                                      null) {
                                    final String phone =
                                        list.bookingModel![0].clientPhone;
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
                                icon: Icon(
                                  Icons.phone_outlined,
                                  color: Colors.blue,
                                  size: 32.r,
                                ),
                              ),
                            ),
                            // CircleAvatar(
                            //   radius: 24.r,
                            //   backgroundColor: Colors.grey[100],
                            //   child: IconButton(onPressed: () {
                            //
                            //   }, icon: Icon(Icons.location_on ,color: Colors.blue,size: 30.r,)),
                            // ),
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.grey[100],
                              child: IconButton(
                                onPressed: () {
                                  final types.User workshopUser = types.User(
                                    id: list.bookingModel![0].customerId,
                                    // نفس الـ uid الخاص بالورشة
                                    firstName: list.bookingModel![0].clientName,
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ChatClientScreenWorkshop(
                                            otherUser: workshopUser,
                                          ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.message,
                                  color: Colors.blue,
                                  size: 28.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(height: 12.h),
                        Container(
                          height: 55.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.r,
                                color: Colors.grey.shade200,
                                blurStyle: BlurStyle.solid,
                                spreadRadius: .5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              list.bookingModel![0].clientName,
                              style: AppTextStyle.fontStyleGrey16400w.copyWith(
                                color: ColorApp.greyColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          height: 55.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.r,
                                color: Colors.grey.shade200,
                                blurStyle: BlurStyle.solid,
                                spreadRadius: .5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              list.companyName,
                              style: AppTextStyle.fontStyleGrey16400w.copyWith(
                                color: ColorApp.greyColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          height: 55.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.r,
                                color: Colors.grey.shade200,
                                blurStyle: BlurStyle.solid,
                                spreadRadius: .5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              list.specifications,
                              style: AppTextStyle.fontStyleGrey16400w.copyWith(
                                color: ColorApp.greyColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 55.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: ColorApp.fieldGrey,
                                  border: Border.all(color: ColorApp.greyLight),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10.r,
                                      color: Colors.grey.shade200,
                                      blurStyle: BlurStyle.solid,
                                      spreadRadius: .5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    list.countryManufacture,
                                    style: AppTextStyle.fontStyleGrey16400w
                                        .copyWith(
                                          color: ColorApp.greyColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Container(
                                height: 55.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: ColorApp.fieldGrey,
                                  border: Border.all(color: ColorApp.greyLight),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10.r,
                                      color: Colors.grey.shade200,
                                      blurStyle: BlurStyle.solid,
                                      spreadRadius: .5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    list.yearManufacture,
                                    style: AppTextStyle.fontStyleGrey16400w
                                        .copyWith(
                                          color: ColorApp.greyColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          height: 65.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: ColorApp.fieldGrey,
                            border: Border.all(color: ColorApp.greyLight),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.r,
                                color: Colors.grey.shade200,
                                blurStyle: BlurStyle.solid,
                                spreadRadius: .5,
                              ),
                            ],
                          ),

                          child: Center(
                            child: Text(
                              "${list.price} EG",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.font18BlackW600.copyWith(
                                color: ColorApp.mainApp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                        CostumeButtonApp(title: "Done"),
                        SizedBox(height: 32.h),
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
