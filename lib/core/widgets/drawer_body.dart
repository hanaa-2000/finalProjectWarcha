import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/splash/splash_screen.dart';
import 'package:warcha_final_progect/features/workshop/home/logic/workshop_home_cubit.dart';

class DrawerBody  extends StatefulWidget {
  const DrawerBody({super.key});

  @override
  State<DrawerBody> createState() => _DrawerBodyState();
}

class _DrawerBodyState extends State<DrawerBody> {
  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Column(
                  children: [
                    Text(
                      "Available",
                      style: AppTextStyle.font18BlackW600,
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      height: 1.h,
                      width: 250.w,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),

                BlocConsumer<WorkshopHomeCubit, WorkshopHomeState>(
                  listener: (context, state) {
                    if(state is MechanicalAdded){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mechanical is Added Successfully")));
                    }
                  },
                  builder: (context, state) {
                    if (state is MechanicalLoading) {
                      return CustomLoadingWidget();
                    } else if (state is MechanicalLoaded) {
                      var list = state.mechanical.reversed.toList();

                      return Column(
                        children: [

                          ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<WorkshopHomeCubit>().toggleSelection(list[index]);
                                  // setState(() {
                                  //   BlocProvider.of<WorkshopHomeCubit>(context).getPeople();
                                  //
                                  // });
                                },
                                onDoubleTap:() {
                                  context.read<WorkshopHomeCubit>().deletePerson(list[index]);
                                } ,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 24.h,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color:  context.read<WorkshopHomeCubit>().selectedNames.contains(list[index]) ? Colors.blue : Colors.grey,
                                  ),
                                  child: Center(
                                    child: Text(
                                      list[index],
                                      style: AppTextStyle.font16WhiteMedium
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: list.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                          )
                        ],
                      );
                    } else if (state is MechanicalError) {
                      return CustomErrorWidget(
                        errorMessage: state.message,
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),


              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  // حذف بيانات التخزين المحلي
                  await SharedPrefHelper.clear();

                  // تسجيل الخروج من Firebase
                  await FirebaseAuth.instance.signOut();

                  log("✅ تم تسجيل الخروج");

                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SplashScreen()),
                          (Route<dynamic> route) => false,
                    );
                  }
                } catch (e) {
                  log("❌ خطأ أثناء تسجيل الخروج: $e");

                  if (context.mounted) {
                    Navigator.of(context).pop(); // إغلاق اللودينج
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("حدث خطأ أثناء تسجيل الخروج")),
                    );
                  }
                }
              },

              backgroundColor: Colors.blue,
              child: Icon(Icons.logout, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                showDetailsDialog(context);
              },
              backgroundColor: Colors.blue,
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
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
            style: AppTextStyle.fontStyleGrey12400w.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add other mechanical craftsmen?",
                  style: AppTextStyle.font16BlackW700.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  // textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                AppTextFormField(
                    controller: nameController,
                    labelText: "Added....", validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return "Please enter your mechanical name";
                  }
                  return "";
                }),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorApp.mainApp,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 20.w),
              ),
              onPressed: () {
                // Navigator.pop(context)context;
                if(!formKey.currentState!.validate()){
                  BlocProvider.of<WorkshopHomeCubit>(context).addPerson(nameController.text);
                  Navigator.of(context).pop();
                  nameController.clear();
                }
              },
              child: Text(
                "Done",
                style: AppTextStyle.font18BlackW600.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
