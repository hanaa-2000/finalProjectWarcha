import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/workshop/profile/data/model/profile_user.dart';
import 'package:warcha_final_progect/features/workshop/profile/data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userRepository) : super(ProfileInitial());
  final ProfileRepo _userRepository;

  // String startTime = DateFormat("hh:mm a").format(DateTime.now());
  // String endTime = DateFormat("hh:mm a")
  //     .format(DateTime.now().add(const Duration(minutes: 45)));

  final prefs =  SharedPreferences.getInstance();

  Future<void> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    String? name = prefs.getString('name');
    String? phone = prefs.getString('phone');
    String? id = prefs.getString('id');

    String? location = prefs.getString('location');

    print('الاسم: $name');
    print('الهاتف: $phone');
    print('الموقع: $location');
    print("object :${id}");
  }
  void fetchUserProfile() async{
    emit(UserLoading());
    _userRepository.getUserProfile().listen(
      (userData)async {
        if (userData != null) {
          await SharedPrefHelper.setString("name", userData.name);
          await SharedPrefHelper.setString("phone", userData.phone);
          await SharedPrefHelper.saveDataByKey("id", userData.uid);
          await SharedPrefHelper.setString("longitude", userData.longitude!);
          await SharedPrefHelper.setString("latitude", userData.latitude!);
          await SharedPrefHelper.setString("location", userData.location!);

          emit(UserSuccess(userData));
        } else {
          emit(UserError("المستخدم غير موجود"));
        }
      },
      onError: (e) {
        emit(UserError("خطأ في جلب البيانات: $e"));
      },
    );
  }

  // رفع صورة الملف الشخصي
  // Future<void> uploadProfileImage(File imageFile) async {
  //   try {
  //     emit(UserLoading());
  //     final imageUrl = await _userRepository.uploadProfileImage(imageFile);
  //     emit(UserUpdated());
  //     fetchUserProfile(); // إعادة تحميل البيانات بعد التحديث
  //   } catch (e) {
  //     emit(UserError("فشل رفع الصورة"));
  //   }
  // }

  bool checkIfOpen(String startTime, String endTime) {
    try {
      final now = DateTime.now();

      if (startTime.isEmpty || endTime.isEmpty) {
        return false;
      }

      // تحويل الوقت المدخل إلى كائنات DateTime
      final parsedStart = DateFormat("hh:mm a").parse(startTime);
      final parsedEnd = DateFormat("hh:mm a").parse(endTime);

      // إنشاء كائنات DateTime باستخدام التاريخ الحالي مع وقت الافتتاح والإغلاق
      final todayStart = DateTime(
        now.year,
        now.month,
        now.day,
        parsedStart.hour,
        parsedStart.minute,
      );
      final todayEnd = DateTime(
        now.year,
        now.month,
        now.day,
        parsedEnd.hour,
        parsedEnd.minute,
      );

      // في حال كان وقت الإغلاق بعد منتصف الليل (مثلاً 3 AM)
      if (parsedEnd.isBefore(parsedStart)) {
        // إذا كان وقت الإغلاق قبل وقت الفتح، فإن الإغلاق يحدث في اليوم التالي
        final nextDayEnd = todayEnd.add(Duration(days: 1));
        return now.isAfter(todayStart) || now.isBefore(nextDayEnd);
      }

      // التحقق إذا كان الوقت الحالي بين وقت الفتح والإغلاق
      return now.isAfter(todayStart) && now.isBefore(todayEnd);
    } catch (e) {
      print("Error parsing time: $e");
      return false;
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Reference ref = FirebaseStorage.instance.ref().child(
        "profile_images/$userId.jpg",
      );

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadURL =
          await snapshot.ref.getDownloadURL(); // 🔹 الحصول على رابط الصورة

      // 🔹 تحديث الصورة في Firestore
      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(userId)
          .update({"profileImage": downloadURL});

      emit(UserImageUpdated(downloadURL)); // 🔹 تحديث الـ Cubit بالرابط الجديد
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUserProfile(
    String name,
    String email,
    String profileImage,
    String phone,
    String location,
    String longitude,
    String latitude,
    String startTime,
    String endTime,
    bool isOpened,
  ) async {
    try {
      emit(UserLoading());
      await _userRepository.updateUserProfile(
        name,
        email,
        profileImage,
        phone,
        location,
        startTime,
        endTime,
        longitude,
        latitude,
        isOpened,
      );
      emit(UserUpdated());
      fetchUserProfile(); // إعادة تحميل البيانات بعد التحديث
    } catch (e) {
      emit(UserError("فشل تحديث البيانات"));
    }
  }
}
