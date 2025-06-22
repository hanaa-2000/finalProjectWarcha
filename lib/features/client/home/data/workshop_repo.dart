import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/client/home/data/appointment_model.dart';
import 'workshop_model.dart';

class WorkshopRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId=FirebaseAuth.instance.currentUser!.uid;

  Future<List<WorkshopModel>> getAllWorkshops() async {
    final querySnapshot = await _firestore
        .collection(usersCollection)
        .where("userType", isEqualTo: "workshop")
        .get();
    List<WorkshopModel> workshops =  querySnapshot.docs
        .map((doc) => WorkshopModel.fromJson(doc.data() ,doc.id))
        .toList();
    // تحديث حالة كل ورشة بناءً على SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    for (var workshop in workshops) {
      final key = _bookingKey(userId,workshop.id);
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final data = jsonDecode(jsonString);
        // تحديث الحالة لو كانت موجودة
        workshop.isBooked = data['isBooked'] == true;
      }
    }
    return workshops;
  }


  Future<void> addBooking(AppointmentModel booking) async {
    await _firestore.collection(ordersCollection).doc(booking.id).set(booking.toJson());
  }



  // final String bookingsCollection = 'bookings';

  Future<void> saveBookingStateFirebase(String workshopId, bool isBooked, String userId) async {
    try {
      await _firestore.collection(ordersCollection).doc('$userId-$workshopId').set({
        'userId': userId,
        'workshopId': workshopId,
        'isBooked': isBooked,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error saving booking state: $e');
    }
  }

  Future<Map<String, dynamic>?> getBookingState(String workshopId, String userId) async {
    try {
      final doc = await _firestore.collection(ordersCollection).doc('$userId-$workshopId').get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error getting booking state: $e');
    }
  }

  Future<void> cancelBooking(String workshopId, String userId) async {
    try {
      await _firestore.collection(ordersCollection).doc('$userId-$workshopId').update({
        'isBooked': false,
      });
    } catch (e) {
      throw Exception('Error canceling booking: $e');
    }
  }
  Future<bool> isWorkshopBooked(String userId, String workshopId) async {
    try {
      final doc = await _firestore
          .collection(ordersCollection)
          .doc('$userId-$workshopId')
          .get();

      if (doc.exists) {
        final data = doc.data();
        return data?['isBooked'] == true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error checking booking: $e');
    }
  }

//String _bookingKey(String workshopId) => 'booking_state_$workshopId';
String _bookingKey(String userId, String workshopId) =>
    'booking_state_${userId}_$workshopId';
// حفظ حالة الحجز لورشة معينة
Future<void> saveBookingState(String userId,String workshopId, bool isBooked) async {
  final prefs = await SharedPreferences.getInstance();
  final stateJson = jsonEncode({
    'userId': userId,
    'workshopId': workshopId,
    'isBooked': isBooked,
  });
  await prefs.setString(_bookingKey(userId,workshopId), stateJson);
}

// تحميل حالة الحجز من SharedPreferences باستخدام المفتاح الخاص بالورشة
Future<Map<String, dynamic>?> getBookingStateJson(String userId,String workshopId) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(_bookingKey(userId ,workshopId));
  if (jsonString != null) {
    return jsonDecode(jsonString);
  }
  return null;
}


}



