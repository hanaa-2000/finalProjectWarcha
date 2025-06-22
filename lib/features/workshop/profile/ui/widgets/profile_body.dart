import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/workshop/profile/logic/profile_cubit.dart';
import 'package:warcha_final_progect/features/workshop/profile/ui/widgets/edit_profile_screen.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  void initState() {
    BlocProvider.of<ProfileCubit>(context).fetchUserProfile();
    super.initState();
  }
  String startTime = DateFormat("hh:mm a").format(DateTime.now());
  String endTime = DateFormat(
    "hh:mm a",
  ).format(DateTime.now().add(const Duration(minutes: 45)));
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is UserLoading) {
              return CustomLoadingWidget();
            } else if (state is UserSuccess) {
              final user = state.user;

              return Column(
                children: [
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 75.r,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child:
                                  (state.user.profileImage.isNotEmpty
                                      ? Image.network(
                                        state.user.profileImage,
                                        width: 150.r,
                                        height: 150.r,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.blue,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.account_circle,
                                                  size: 150.r,
                                                  color: Colors.grey[300],
                                                ),
                                      )
                                      : Icon(
                                        Icons.account_circle,
                                        color: Colors.grey[300],
                                        size: 150.r,
                                      )),
                            ),
                          ),

                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colors.grey[300],
                              child: CircleAvatar(
                                radius: 17.r,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.blue,
                                    size: 22.r,
                                  ),
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => EditProfileScreen(),
                                      ),
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 80.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                side: BorderSide(color: ColorApp.greyLight),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "${user.name}",
                                style: AppTextStyle.font18BlackW600,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                side: BorderSide(color: ColorApp.greyLight),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "${user.email}",
                                style: AppTextStyle.font18BlackW600,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                side: BorderSide(color: ColorApp.greyLight),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "${user.phone}",
                                style: AppTextStyle.font18BlackW600,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                side: BorderSide(color: ColorApp.greyLight),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                user.location == ''?"Location Not Found  ": user.location!,
                                style: AppTextStyle.font18BlackW600,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),

                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  color: Colors.blue.shade200,
                                ),
                              ],
                              color: Colors.white,
                            ),
                            height: 55.h,
                            width: 150.w,

                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Text(
                                    state.user.isOpen ? "Opened" : "Closed",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      state.user.isOpen
                                          ? Colors.green
                                          : Colors.black54,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  state.user.isOpen
                                      ? Icon(
                                    Icons.build_circle,
                                    color: Colors.green,
                                  )
                                      : Icon(
                                    Icons.build_circle,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                      side: BorderSide(
                                        color: ColorApp.greyLight,
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${state.user.startTime ==''?startTime:state.user.startTime}",
                                      style: AppTextStyle.font18BlackW600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                      side: BorderSide(
                                        color: ColorApp.greyLight,
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${user.endTime==''?endTime:user.endTime}",
                                      style: AppTextStyle.font18BlackW600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  //Spacer(),
                ],
              );
            } else if (state is UserError) {
              return CustomErrorWidget(errorMessage: state.message);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
