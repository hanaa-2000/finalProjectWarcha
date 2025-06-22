import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/logic/store_cubit.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController countryManufactureController =
      TextEditingController();
  final TextEditingController specificationsController =
      TextEditingController();
  final TextEditingController yearManufactureController =
      TextEditingController();
  final priceController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  String imagePath = '';
  bool isLoading = false;

  @override
  void dispose() {
    companyNameController.dispose();
    countryManufactureController.dispose();
    specificationsController.dispose();
    yearManufactureController.dispose();
    priceController.dispose();
    super.dispose();
  }

  bool isButtonEnabled = false;
  bool isTimeout = false;

  void _validateButton() {
    setState(() {
      isButtonEnabled =
          companyNameController.text.isNotEmpty &&
          specificationsController.text.isNotEmpty &&
          countryManufactureController.text.isNotEmpty &&
          yearManufactureController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          imagePath.isNotEmpty;
    });
  }

  @override
  void initState() {
    companyNameController.addListener(_validateButton);
    specificationsController.addListener(_validateButton);
    countryManufactureController.addListener(_validateButton);
    yearManufactureController.addListener(_validateButton);
    priceController.addListener(_validateButton);
    super.initState();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    ); // أو ImageSource.camera

    if (image != null) {
      setState(() {
        imagePath = image.path; // تخزين المسار الذي تم اختياره
      }); // هذا هو المسار الذي يجب عليك استخدامه
      // الآن استخدم هذا المسار لرفع الصورة
    }
  }

  void _submitForm() {
    if (!formKey.currentState!.validate() && isButtonEnabled) {
      setState(() {
        isLoading = true; // بدء عملية التحميل
        isTimeout = false; // إعادة تعيين المهلة
      });

      // بدء مؤقت للمهلة
      Timer(Duration(seconds: 60), () {
        if (isLoading) {
          setState(() {
            isLoading = false; // التوقف عن التحميل
            isTimeout = true; // تعيين المهلة كعند عدم الاستجابة
          });

          // عرض رسالة تفيد بوجود مشكلة
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Operation timed out. Please check your connection and try again.')));
        }
      });

      // تقديم المنتج
      // هذه الوظيفة ستعمل في الخلفية
      context.read<StoreCubit>().addProduct(
        companyNameController.text,
        countryManufactureController.text,
        specificationsController.text,
        yearManufactureController.text,
        priceController.text,
        imagePath,

      );

      // التعامل مع الحالة بعد الطلب

            setState(() {
              isLoading = false; // إنهاء التحميل
            });
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: "Confirm",
              text: "Product Added Successfully!",
              confirmBtnText: "OK",
              onConfirmBtnTap: () {
                Navigator.of(context).pop(); // إغلاق الحوار
                Navigator.of(context).pop(); // إغلاق الحوار
              },
            );
            print("Addeddddd");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Added Successfully!')));


    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text("Add Product", style: AppTextStyle.font18BlackW600),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<StoreCubit, StoreState>(
          listener: (context, state) {
            if (state is ProductSuccess) {
              print("Addeddd");
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Product Added')));
            } else if (state is ProductDeleted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Product Deleted')));
            } else if (state is ProductFailure) {
              print('Error: ${state.errorMsg}');
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Error: ${state.errorMsg}')),
              // );
            }
          },
          builder: (context, state) {
            if (isLoading || state is ProductLoading) {
              return CustomLoadingWidget(); // عرض مؤشر التحميل
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 80.r,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child:
                                imagePath != ''
                                    ? Image.file(
                                      File(imagePath),
                                      fit: BoxFit.cover,
                                      width: 150.r,
                                      height: 150.r,
                                    )
                                    : SvgPicture.asset("assets/images/car_accssec.svg",width: 150,height: 150,colorFilter: ColorFilter.mode(Colors.grey,BlendMode.srcIn),),


                            // Icon(
                            //           Icons.account_circle,
                            //           color: Colors.grey[200],
                            //           size: 140,
                            //         ),
                          ),
                        ),

                        // زر تغيير الصورة
                        Positioned(
                          bottom: 30,
                          right:30,
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
                                  await pickImage();
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

                    SizedBox(height: 48.h),
                    AppTextFormField(
                      labelText: "Company Name",
                      keyboardType: TextInputType.text,
                      controller: companyNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your company name";
                        }
                        return "";
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppTextFormField(
                      labelText: "Specifications",
                      keyboardType: TextInputType.text,
                      controller: specificationsController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Specifications";
                        }
                        return "";
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppTextFormField(
                      labelText: "Country of Manufacture",
                      keyboardType: TextInputType.text,
                      controller: countryManufactureController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Country of Manufacture";
                        }
                        return "";
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppTextFormField(
                      labelText: "Year of Manufacture",
                      keyboardType: TextInputType.datetime,
                      controller: yearManufactureController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Year of Manufacture";
                        }
                        return "";
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppTextFormField(
                      labelText: "Price",
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your price";
                        }
                        return "";
                      },
                    ),
                    SizedBox(height: 48.h),

                    CostumeButtonApp(
                      title: "Submit",
                      onPressed:isButtonEnabled ? _submitForm : null,

                    ),
                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
