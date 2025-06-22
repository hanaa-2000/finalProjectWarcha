import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/workshop/profile/data/model/profile_user.dart';

class ProfileRepo {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Stream<ProfileUser?> getUserProfile() {
    return _firestore
        .collection(usersCollection)
        .doc(_auth.currentUser?.uid)
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            return ProfileUser.fromMap(doc.data()!);
          }
          return null;
        });
  }

  Future<void> updateUserProfile(
    String name,
    String email,
    String profileImage,
    String phone,
    String location,
    String startTime,
    String endTime,
    String longitude,
    String latitude,
    bool isOpen,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection(usersCollection).doc(userId).update({
        'userName': name,
        'email': email,
        'profileImage': profileImage,
        'phone': phone,
        'location': location,
        'startTime': startTime,
        'endTime': endTime,
        'isOpen': isOpen,
        'longitude':longitude,
        'latitude':latitude,
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

  // Future<String> getCurrentCoordinates() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw 'Location services are disabled.';
  //   }
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw 'Location permissions are denied';
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     throw 'Location permissions are permanently denied.';
  //   }
  //
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   return '${position.latitude}, ${position.longitude}';
  // }
}
