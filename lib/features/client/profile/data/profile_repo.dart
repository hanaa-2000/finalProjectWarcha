import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/client/profile/data/profie_client_model.dart';

class ProfileClientRepo {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<ProfileClientModel?> getClientById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(usersCollection)
          .doc(id)
          .get();

      if (docSnapshot.exists) {
        return ProfileClientModel.fromJson(docSnapshot.data()!, docSnapshot.id);
      } else {
        return null; // لو الـ client مش موجود
      }
    } catch (e) {
      print("🔥 Error getting client by id: $e");
      return null;
    }
  }

  Future<ProfileClientModel?> getUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("❌ No user is currently signed in.");
        return null;
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        print("object${docSnapshot.id}");
        return ProfileClientModel.fromJson(docSnapshot.data()!, docSnapshot.id);

      } else {
        print("⚠️ No user document found for UID: ${user.uid}");
        return null;
      }
    } catch (e) {
      print("🔥 Error in getUser(): $e");
      return null;
    }
  }

  Future<void> updateClientProfile(
      String name,
      String email,
      String profileImage,
      String phone,
        ) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection(usersCollection).doc(userId).update({
        'userName': name,
        'email': email,
        'profileImage': profileImage,
        "phone":phone,
       });
    }
  }

  // رفع الصورة إلى Firebase Storage
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final userId = _auth.currentUser?.uid;
      final ref = _storage.ref().child("profile_images/$userId.jpg");
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("فشل رفع الصورة");
    }
  }


}