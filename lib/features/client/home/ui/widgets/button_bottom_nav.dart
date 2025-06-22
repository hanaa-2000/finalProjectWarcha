import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcha_final_progect/core/helper/location_service.dart';
import 'package:warcha_final_progect/core/helper/show_toast_message.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/costum_button_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/client/home/data/appointment_model.dart';
import 'package:warcha_final_progect/features/client/home/data/bookingModel.dart';
import 'package:warcha_final_progect/features/client/home/logic/workshops_cubit.dart';

class ButtonBottomNav extends StatefulWidget {
  const ButtonBottomNav({
    super.key,
    required this.workshopId,
    this.isBooked = false,
  });

  final String workshopId;
  final bool isBooked;

  @override
  State<ButtonBottomNav> createState() => _ButtonBottomNavState();
}

class _ButtonBottomNavState extends State<ButtonBottomNav> {
  // BookingModel booking = BookingModel(
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: CostumeButtonApp(
        title: "Book an appointment",
        onPressed: () {
          showDraggableBottomSheet(context);
        },
      ),
    );
  }

  TextEditingController addressController = TextEditingController();
  TextEditingController carBrandController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController problemController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isButtonEnabled = false;
  bool isTimeout = false;
  bool isLoading = false;
  bool isBooked = false;
  String? bookingId; // Store the booking ID for cancellation

  String userName = '';
  String longitude = '';
  String latitude = '';

  @override
  void initState() {
    super.initState();
    carModelController.addListener(_validateButton);
    addressController.addListener(_validateButton);
    problemController.addListener(_validateButton);
    carBrandController.addListener(_validateButton);
    phoneController.addListener(_validateButton);

    print("Workshop ID: ${widget.workshopId}");
    context.read<WorkshopsCubit>().checkIfWorkshopBooked(widget.workshopId);
    getState();
  }

  @override
  void dispose() {
    carModelController.dispose();
    addressController.dispose();
    problemController.dispose();
    carBrandController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _validateButton() {
    final phone = phoneController.text;
    final isValidPhone = RegExp(r'^01[0-9]{9}$').hasMatch(phone);

    if (!isValidPhone && phone.isNotEmpty) {
      showToastMessage(
        context: context,
        message: "Invalid phone number. Must start with 01 and be 11 digits.",
      );
    }

    setState(() {
      isButtonEnabled = isValidPhone &&
          carBrandController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          problemController.text.isNotEmpty &&
          carModelController.text.isNotEmpty;
    });
  }

  Future<void> getState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? '';
      isBooked = prefs.getBool('booking_${widget.workshopId}') ?? widget.isBooked;
      print("Initial isBooked from SharedPreferences: $isBooked");
    });

    // Fetch booking ID if booked
    if (isBooked) {
      final bookingDoc = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('workshopId', isEqualTo: widget.workshopId)
          .get();
      if (bookingDoc.docs.isNotEmpty) {
        setState(() {
          bookingId = bookingDoc.docs.first.id;
          print("Fetched booking ID: $bookingId");
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && isButtonEnabled) {
      if (latitude.isEmpty || longitude.isEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Please fetch your location first')),
        // );
        showToastMessage(
          context: context,
          message: 'Please fetch your location first',
        );
        return;
      }

      // Check if user already has a booking
      final userBookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userBookings.docs.isNotEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('You already have an active booking. Please cancel it first.')),
        // );
        showToastMessage(
          context: context,
          message: 'You already have an active booking. Please cancel it first.',
        );
        return;
      }

      // Check if user already booked this workshop
      final workshopBookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('workshopId', isEqualTo: widget.workshopId)
          .get();
      if (workshopBookings.docs.isNotEmpty) {
        // sh
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('You already booked this workshop.')),
        // );
        showToastMessage(
          context: context,
          message: 'You already booked this workshop.',
        );

        return;
      }

      setState(() {
        isLoading = true;
        isTimeout = false;
      });

      final booking = AppointmentModel(
         true,
        clientName: userName,
        address: addressController.text,
        latitude: latitude,
        longtude: longitude,
        carBrand: carBrandController.text,
        carModel: carModelController.text,
        phone: phoneController.text,
        problem: problemController.text,
        id: '', // Will be set in makeBooking
        userId: FirebaseAuth.instance.currentUser!.uid,
        dateTime: DateTime.now().toString(),
        workshopId: widget.workshopId,
      );

      Timer(Duration(seconds: 60), () {
        if (isLoading) {
          setState(() {
            isLoading = false;
            isTimeout = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Operation timed out.')),
          );
        }
      });

      await context.read<WorkshopsCubit>().makeBooking(booking);
      setState(() {
        isLoading = false;
        isBooked = true;
        // Fetch booking ID after successful booking
        FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('workshopId', isEqualTo: widget.workshopId)
            .get()
            .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            setState(() {
              bookingId = snapshot.docs.first.id;
              print("Set booking ID after booking: $bookingId");
            });
          }
        });
      });

     // await context.read<WorkshopsCubit>().bookWorkshopWithDetails(booking);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Confirm",
        text: "Booking Added Successfully!",
        confirmBtnText: "OK",
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close QuickAlert
          Navigator.pop(context); // Close BottomSheet
        },
      );
    }
  }

  Future<void> _cancelBooking() async {
    if (bookingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No booking found to cancel.')),
      );
      return;
    }

    await context.read<WorkshopsCubit>().cancelBooking(bookingId!, widget.workshopId);
    setState(() {
      isBooked = false;
      bookingId = null;
      print("Updated isBooked to false and cleared booking ID");
    });

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Confirm",
      text: "Booking Canceled Successfully!",
      confirmBtnText: "OK",
      onConfirmBtnTap: () {
        Navigator.pop(context); // Close QuickAlert
        Navigator.pop(context); // Close BottomSheet
      },
    );
  }

  void showDraggableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.8,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return BlocListener<WorkshopsCubit, WorkshopsState>(
                  listener: (context, state) {
                    if (state is BookingStatusChecked) {
                      setModalState(() {
                        isBooked = state.isBooked;
                        print("BlocListener updated isBooked: $isBooked");
                      });
                    } else if (state is BookingSuccess) {
                      setModalState(() {
                        isBooked = state.isBooked;
                        print("BlocListener updated isBooked: $isBooked");
                      });
                    } else if (state is BookingError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errMsg)),
                      );
                    }
                  },
                  child: BlocBuilder<WorkshopsCubit, WorkshopsState>(
                    builder: (context, state) {
                      print("BottomSheet rebuilt at ${DateTime.now()}");
                      if (state is BookingLoading) {
                        return CustomLoadingWidget();
                      }
                      if (state is BookingError) {
                        print("BlocBuilder error: ${state.errMsg}");
                        return CustomErrorWidget(errorMessage: "Error: ${state.errMsg}");
                      }

                      return Form(
                        key: _formKey,
                        child: FocusScope(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                                left: 16.w,
                                right: 16.w,
                                top: 16.h,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
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
                                      "Book Appointment",
                                      style: AppTextStyle.font18BlackW600,
                                    ),
                                    SizedBox(height: 16.h),
                                    Divider(color: Colors.grey.shade300),
                                    SizedBox(height: 12.h),
                                    AppTextFormField(
                                      controller: addressController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your address";
                                        }
                                        return null;
                                      },
                                      onTap: () async {
                                        try {
                                          print("Attempting to fetch location...");
                                          Position? position = await LocationService().getCurrentLocation();
                                          if (position != null) {
                                            setModalState(() {
                                              longitude = position.longitude.toString();
                                              latitude = position.latitude.toString();
                                              print("Location set: $latitude, $longitude");
                                            });
                                          } else {
                                            print("Location is null");
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Unable to get location')),
                                            );
                                          }
                                        } catch (e) {
                                          print("Location error: $e");
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Location error: $e')),
                                          );
                                        }
                                      },
                                      labelText: 'Address',
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      "Location: $latitude, $longitude",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    SizedBox(height: 16.h),
                                    AppTextFormField(
                                      controller: carBrandController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your car brand";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      labelText: 'Car Brand',
                                    ),
                                    SizedBox(height: 16.h),
                                    AppTextFormField(
                                      controller: carModelController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your car model";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      labelText: 'Car Model',
                                    ),
                                    SizedBox(height: 16.h),
                                    AppTextFormField(
                                      controller: phoneController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your phone";
                                        }
                                        if (!RegExp(r'^01[0-9]{9}$').hasMatch(value)) {
                                          return "Invalid phone number";
                                        }
                                        return null;
                                      },
                                      labelText: 'Phone',
                                      keyboardType: TextInputType.phone,
                                    ),
                                    SizedBox(height: 16.h),
                                    AppTextFormField(
                                      controller: problemController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your problem";
                                        }
                                        return null;
                                      },
                                      labelText: 'Problem',
                                      keyboardType: TextInputType.text,
                                      maxLines: 3,
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height / 9.5),
                                    Row(
                                      children: [
                                        if (isBooked) ...[
                                          Icon(Icons.check_circle, color: Colors.red),
                                          SizedBox(width: 8.w),
                                        ],
                                        Expanded(
                                          child: CostumeButtonApp(
                                            onPressed: isBooked ? _cancelBooking : (isButtonEnabled ? _submitForm : null),
                                            title: isBooked ? "Cancel Booking" : "Book Now",
                                            color: isBooked ? Colors.grey[400] : ColorApp.mainApp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 32.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
class LocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
// onTap: () async {
// setState(() {});
// try {
// log("تمت الاضافة بنجااااح ");
// Position? position =
// await LocationService()
//     .getCurrentLocation();
// // log(position!.longitude.toString());
// // log(position.latitude.toString());
// if (position != null) {
// log(position.longitude.toString());
// log(position.latitude.toString());
// } else {
// log("تعذر الحصول على الموقع");
// }
//
// setState(() {
// longtude = position!.longitude.toString();
// latitude = position.latitude.toString();
// });
// } catch (e) {
// print("${e}");
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(
// content: Text('Location error: $e'),
// ),
// );
// }
// },
