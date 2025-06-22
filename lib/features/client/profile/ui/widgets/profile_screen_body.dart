import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/extension.dart';
import 'package:warcha_final_progect/core/helper/spacing.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/client/profile/logic/profile_client_cubit.dart';
import 'package:warcha_final_progect/features/client/profile/ui/widgets/edit_profile_screen.dart';
import 'package:warcha_final_progect/features/workshop/profile/ui/widgets/edit_profile_screen.dart';

class ProfileScreenBody  extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  @override
  void initState() {
    BlocProvider.of<ProfileClientCubit>(context).getClientById();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileClientCubit, ProfileClientState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    if(state is ClientLoading){
      return CustomLoadingWidget();
    }else if(state is ClientLoaded){
      return Column(
        children: [

          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  height: MediaQuery.of(context).size.height/3,
                  decoration:BoxDecoration(
                    color: Colors.blue,
                  ) ,
                ),

              ),
              Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                children: [
                  IconButton(onPressed: () async{
                    Navigator.of(context).pop();


                  }, icon: Icon(Icons.arrow_back_ios_new_outlined ,color: Colors.white,),
                  ),
                  IconButton(onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileClientScreen(),));

                  }, icon: Icon(Icons.edit ,color: Colors.white,),
                  ),
                ],
              )
              ),
              Positioned(
                top:MediaQuery.of(context).size.height/4,
               // bottom: 80,
                child: Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24.r),
                      topLeft: Radius.circular(24.r),
                    ),
                  ),
                  //clipBehavior: Clip.none,
                 // child:
                  ),
                ),
              Positioned(
                  top: MediaQuery.of(context).size.height / 6,
                  right: 0,
                  left: 0,
                  child: SingleChildScrollView(
                    child: Column(
                                    children: [
                    ClipOval(
                      child:
                      (state.client.image!.isNotEmpty)
                          ? Image.network(
                        state. client.image!,
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
                          : Image.asset("assets/images/user_image.png" , width:120.w,height: 120.w,) ,
                      // Icon(
                      //   Icons.account_circle,
                      //   color: Colors.grey[300],
                      //   size: 150.r,
                      // ),

                    ),
                    verticalSpace(30),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      margin:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(color: ColorApp.greyLight),
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "${state.client.name}",
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
                      margin:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(color: ColorApp.greyLight),
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "${state.client.email}",
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
                      margin:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(color: ColorApp.greyLight),
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "${state.client.phone}",
                          style: AppTextStyle.font18BlackW600,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h,),

                                    ],
                                  ),
                  ))
            ],
              )

            ],
          );


    }else if(state is ClientError){
      return CustomErrorWidget(errorMessage: state.message);
    }
    return SizedBox.shrink();

  },
);
  }
}
