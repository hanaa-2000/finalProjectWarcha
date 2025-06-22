import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:warcha_final_progect/core/helper/location_service.dart';
import 'package:warcha_final_progect/core/helper/spacing.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/workshop/profile/data/repo/profile_repo.dart';
import 'package:warcha_final_progect/features/workshop/profile/logic/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // DateTime mysSelectedDay = DateTime.now();
  // DateTime myFocusedDay = DateTime.now();
  String _profileImage = "";
  bool isOpen = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  // اختيار صورة من المعرض أو الكاميرا
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // رفع الصورة عند الضغط على الزر
  void _uploadImage() {
    if (_selectedImage != null) {
      context.read<ProfileCubit>().uploadProfileImage(_selectedImage!);
    }
  }

  String startTime = DateFormat("hh:mm a").format(DateTime.now());
  String endTime = DateFormat(
    "hh:mm a",
  ).format(DateTime.now().add(const Duration(minutes: 45)));
  String longitude = '';
  String latitude = '';

  Future<void> getStartTime(BuildContext context) async {
    TimeOfDay? pickStartTime = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue.shade400,
            colorScheme: ColorScheme.light(primary: Colors.blue.shade400),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickStartTime != null) {
      setState(() {
        startTime = pickStartTime.format(context);
      });
    }
  }

  Future<void> getEndTime(BuildContext context) async {
    TimeOfDay? pickEndTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue.shade400,
            colorScheme: ColorScheme.light(primary: Colors.blue.shade400),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (pickEndTime != null) {
      setState(() {
        endTime = pickEndTime.format(context); // حفظ وقت الإغلاق
      });
    }
  }

  @override
  void initState() {
    setState(() {
      isOpen = context.read<ProfileCubit>().checkIfOpen(
        startTime,
        endTime,
      ); // تحقق من حالة المتجر
    });
    super.initState();
  }

  bool useCurrentLocation = false;

  Future<String> getCurrentCoordinates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return '${position.latitude}, ${position.longitude}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text("Edit Profile", style: AppTextStyle.font18BlackW600),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 12.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: BlocProvider(
                  create:
                      (context) =>
                          ProfileCubit(ProfileRepo())..fetchUserProfile(),
                  child: BlocConsumer<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state is UserUpdated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم تحديث البيانات بنجاح")),
                        );
                      }
                      if (state is UserImageUpdated) {
                        setState(() {
                          _profileImage =
                              state
                                  .downloadImage; // 🔹 تحديث الصورة فور استلام الرابط الجديد
                          _selectedImage =
                              null; // 🔹 مسح الصورة المؤقتة بعد الرفع
                        });
                      }
                      if (state is GetStartTimeSuccess ||
                          state is GetEndTimeSuccess) {
                        print('startRTime:${state}');
                        // تحديث حالة المتجر عند اختيار أوقات جديدة
                      }
                    },
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return CustomLoadingWidget();
                      } else if (state is UserSuccess) {
                        _nameController.text = state.user.name;
                        _emailController.text = state.user.email;
                        _profileImage = state.user.profileImage;
                        _phoneController.text = state.user.phone;
                        return Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 75.r,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child:
                                        _selectedImage != null
                                            ? Image.file(
                                              _selectedImage!,
                                              width: 150.r,
                                              height: 150.r,
                                              fit: BoxFit.cover,
                                            )
                                            : (_profileImage.isNotEmpty
                                                ? Image.network(
                                                  _profileImage,
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
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: Colors.blue,
                                                          ),
                                                    );
                                                  },
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Icon(
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

                                // زر تغيير الصورة
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
                                          Icons.camera_alt_outlined,
                                          color: Colors.blue,
                                          size: 22.r,
                                        ),
                                        onPressed: () async {
                                          await _pickImage();
                                          setState(
                                            () {},
                                          ); // تحديث الواجهة بعد اختيار الصورة
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
                                SizedBox(height: 10),

                                // زر رفع الصورة
                                // ElevatedButton(
                                //   onPressed: _uploadImage,
                                //   child: Text("رفع الصورة"),
                                // ),
                                SizedBox(height: 80.h),

                                AppTextFormField(
                                  controller: _nameController,
                                  labelText: "Username",
                                  validator: (p0) {},
                                ),
                                SizedBox(height: 16.h),
                                AppTextFormField(
                                  controller: _emailController,
                                  labelText: "Email",
                                  validator: (p0) {},
                                  readOnly: true,
                                ),
                                SizedBox(height: 16.h),
                                AppTextFormField(
                                  controller: _phoneController,
                                  labelText: "Phone",
                                  validator: (p0) {},
                                ),
                                SizedBox(height: 16.h),
                                Column(
                                  children: [
                                    Text(
                                      "Choose how to specify the address:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<bool>(
                                          value: false,
                                          groupValue: useCurrentLocation,
                                          onChanged: (val) {
                                            setState(() {
                                              useCurrentLocation = val!;
                                            });
                                          },
                                          focusColor: Colors.blue,
                                          activeColor: Colors.blue,
                                        ),
                                        Text("Address manually"),

                                        Radio<bool>(
                                          value: true,
                                          groupValue: useCurrentLocation,
                                          onChanged: (val) async {
                                            setState(() {
                                              useCurrentLocation = val!;
                                            });
                                            try {
                                              log("تمت الاضافة بنجااااح ");
                                              Position? position =
                                                  await LocationService()
                                                      .getCurrentLocation();
                                              // log(position!.longitude.toString());
                                              // log(position.latitude.toString());
                                              if (position != null) {
                                                log(
                                                  position.longitude.toString(),
                                                );
                                                log(
                                                  position.latitude.toString(),
                                                );
                                              } else {
                                                log("تعذر الحصول على الموقع");
                                              }

                                              setState(() {
                                                longitude =
                                                    position!.longitude
                                                        .toString();
                                                latitude =
                                                    position.latitude
                                                        .toString();
                                              });
                                            } catch (e) {
                                              print("${e}");
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Location error: $e',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          activeColor: Colors.blue,
                                        ),
                                        Text("Current location"),
                                      ],
                                    ),

                                    if (!useCurrentLocation)
                                      AppTextFormField(
                                        controller: _locationController,
                                        labelText: "Location",
                                        validator: (p0) {},
                                        onChanged: (val) async {
                                          try {
                                            log("تمت الاضافة بنجااااح ");
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Succe")));

                                            Position? position =
                                                await LocationService()
                                                    .getCurrentLocation();
                                            // log(position!.longitude.toString());
                                            // log(position.latitude.toString());
                                            if (position != null) {
                                              log(
                                                position.longitude.toString(),
                                              );
                                              log(position.latitude.toString());
                                            } else {
                                              
                                              log("تعذر الحصول على الموقع");
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location could not be found")));
                                            }

                                            setState(() {
                                              longitude =
                                                  position!.longitude
                                                      .toString();
                                              latitude =
                                                  position.latitude.toString();
                                            });
                                          } catch (e) {
                                            print("${e}");
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Location error: $e',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                  ],
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
                                          isOpen ? "Opened" : "Closed",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                isOpen
                                                    ? Colors.green
                                                    : Colors.black54,
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        isOpen
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 16.h,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              side: BorderSide(
                                                color: ColorApp.greyLight,
                                              ),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,

                                              children: [
                                                Text(
                                                  "${startTime}",
                                                  style:
                                                      AppTextStyle
                                                          .fontStyleGrey16400w,
                                                ),
                                                horizontalSpace(12),
                                                Icon(Icons.timer_outlined),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          setState(() {
                                            getStartTime(context);
                                            isOpen = context
                                                .read<ProfileCubit>()
                                                .checkIfOpen(
                                                  startTime,
                                                  endTime,
                                                );
                                          });
                                        },
                                      ),
                                    
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 16.h,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              side: BorderSide(
                                                color: ColorApp.greyLight,
                                              ),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "${endTime}",
                                                  style:
                                                      AppTextStyle
                                                          .fontStyleGrey16400w,
                                                ),
                                                horizontalSpace(12),
                                                Icon(Icons.timer_outlined),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          setState(() {
                                            getEndTime(context);
                                            // تحقق من حالة المتجر بعد تحديث وقت الإغلاق
                                            isOpen = context
                                                .read<ProfileCubit>()
                                                .checkIfOpen(
                                                  startTime,
                                                  endTime,
                                                );
                                          });
                                        },
                                      ),

                                      // AppTextFormField(
                                      //   validator: (p0) {},
                                      //   readOnly: true,
                                      //   // ,
                                      //   labelText: startTime,
                                      //   suffixIcon: IconButton(
                                      //     onPressed: () async {
                                      //       setState(() {
                                      //         getStartTime(context);
                                      //         isOpen = context
                                      //             .read<ProfileCubit>()
                                      //             .checkIfOpen(
                                      //               startTime,
                                      //               endTime,
                                      //             );
                                      //       }
                                      //       );
                                      //     },
                                      //     icon: const Icon(
                                      //       Icons.timer_outlined,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                    // Expanded(
                                    //   child: AppTextFormField(
                                    //     validator: (p0) {},
                                    //     readOnly: true,
                                    //
                                    //     //hint: BlocProvider.of<TaskCubit>(context).endTime,
                                    //     labelText: endTime,
                                    //
                                    //     suffixIcon: IconButton(
                                    //       onPressed: () async {
                                    //         setState(() {
                                    //           getEndTime(context);
                                    //           // تحقق من حالة المتجر بعد تحديث وقت الإغلاق
                                    //           isOpen = context
                                    //               .read<ProfileCubit>()
                                    //               .checkIfOpen(
                                    //                 startTime,
                                    //                 endTime,
                                    //               );
                                    //         });
                                    //       },
                                    //       icon: const Icon(
                                    //         Icons.timer_outlined,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (state is UserError) {
                        return CustomErrorWidget(errorMessage: state.message);
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            CostumeButtonApp(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: "قبول",
                  text: "تمت العمليه بنجاح",
                  confirmBtnText: "موافق",
                  onConfirmBtnTap: () {
                    _uploadImage();
                    context.read<ProfileCubit>().updateUserProfile(
                      _nameController.text,
                      _emailController.text,
                      _profileImage,
                      _phoneController.text,
                      _locationController.text,
                      longitude,
                      latitude,
                      startTime,
                      endTime,
                      isOpen,
                    );

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                );
              },
              title: "Update",
            ),
          ],
        ),
      ),
    );
  }
}
