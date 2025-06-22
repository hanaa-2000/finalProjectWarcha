import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/client/profile/data/profile_repo.dart';
import 'package:warcha_final_progect/features/client/profile/logic/profile_client_cubit.dart';

class EditProfileClientScreen  extends StatefulWidget {
  const EditProfileClientScreen({super.key});

  @override
  State<EditProfileClientScreen> createState() => _EditProfileClientScreenState();
}

class _EditProfileClientScreenState extends State<EditProfileClientScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // DateTime mysSelectedDay = DateTime.now();
  // DateTime myFocusedDay = DateTime.now();
  String _profileImage = "";

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _nameController.dispose();
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
@override
  void initState() {
    BlocProvider.of<ProfileClientCubit>(context).getClientById();
    super.initState();
  }
  // رفع الصورة عند الضغط على الزر
  void _uploadImage() {
    if (_selectedImage != null) {
      context.read<ProfileClientCubit>().uploadProfileImage(_selectedImage!);
    }
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
                  ProfileClientCubit(ProfileClientRepo())..getClientById(),
                  child: BlocConsumer<ProfileClientCubit, ProfileClientState>(
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

                    },
                    builder: (context, state) {
                      if (state is ClientLoading) {
                        return CustomLoadingWidget();
                      }
                      if (state is ClientError) {
                        return CustomErrorWidget(errorMessage: state.message);

                      }
                      if(state is ClientLoaded){
                        final user = state.client;
                        _nameController.text=user.name;
                        _emailController.text=user.email;
                        _phoneController.text=user.phone;


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
                              ],
                            ),
                          ],
                        );
                      }
                       return SizedBox.shrink();
                      }

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
                    context.read<ProfileClientCubit>().updateUserProfile(
                      _nameController.text,
                      _emailController.text,
                      _profileImage,
                      _phoneController.text,
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
