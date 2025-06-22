import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/client/profile/data/profie_client_model.dart';
import 'package:warcha_final_progect/features/client/profile/data/profile_repo.dart';
import 'package:warcha_final_progect/features/workshop/profile/data/model/profile_user.dart';

part 'profile_client_state.dart';

class ProfileClientCubit extends Cubit<ProfileClientState> {
  ProfileClientCubit(this.repo) : super(ProfileClientInitial());
final  ProfileClientRepo repo;


final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  User? user = FirebaseAuth.instance.currentUser;


  Future<void> getClientById() async {
    emit(ClientLoading()); // بداية التحميل
    try {
      final docSnapshot = await _firestore
          .collection(usersCollection) // تأكد من استخدام المجموعة الصحيحة
          .doc(user!.uid)
          .get();

      if (docSnapshot.exists) {
        ProfileClientModel client = ProfileClientModel.fromJson(
            docSnapshot.data()!, docSnapshot.id);
        SharedPreferences pref =await  SharedPreferences.getInstance();
        final userName=await pref.setString("userName", client.name);
        final phoneClient = await pref.setString("phone", client.phone);
        final clientId=await pref.setString("clientId", client.id);

        log("${userName}");
        log("${clientId}");
        log("message ${phoneClient}");

        emit(ClientLoaded(client)); // بيانات العميل تم تحميلها بنجاح
      } else {
        emit(ClientError("Client not found")); // إذا لم يكن العميل موجودًا
      }
    } catch (e) {
      print("🔥 Error getting client by id: $e");
      emit(ClientError("Error fetching client data")); // حدث خطأ أثناء الحصول على البيانات
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
      emit(ClientError(e.toString()));
    }
  }

  Future<void> updateUserProfile(
      String name,
      String email,
      String profileImage,
      String phone,

      ) async {
    try {
      emit(ClientLoading());
      await repo.updateClientProfile(
        name,
        email,
        profileImage,
        phone,

      );
      emit(ClientSuccess());
      getClientById(); // إعادة تحميل البيانات بعد التحديث
    } catch (e) {
      emit(ClientError("فشل تحديث البيانات"));
    }
  }
}
