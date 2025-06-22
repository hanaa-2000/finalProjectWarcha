import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/core/notification/notification_item.dart';
import 'package:warcha_final_progect/core/notification/push_notification_service.dart';
import 'package:warcha_final_progect/core/notification/service_notification.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/features/client/home/data/appointment_model.dart';
import 'package:warcha_final_progect/features/client/home/data/reviwes_model.dart';
import 'package:warcha_final_progect/features/client/home/data/workshop_model.dart';
import 'package:warcha_final_progect/features/client/home/data/workshop_repo.dart';

part 'workshops_state.dart';

//
// class WorkshopsCubit extends Cubit<WorkshopsState> {
//   WorkshopsCubit(this._repo) : super(WorkshopsInitial());
//
//   final WorkshopRepository _repo;
//   // جلب الورش
//   Future<void> fetchWorkshops() async {
//     emit(GetWorkshopsLoading());
//     try {
//       final workshops = await _repo.getAllWorkshops();
//       emit(GetWorkshopsSuccess(list: workshops));
//     } catch (e) {
//       emit(GetWorkshopsError(errMsg: e.toString()));
//     }
//   }
// ////////////////////////////  shared
//
//   // تحميل حالة الحجز لورشة معينة
//   Future<void> loadBooking(String userId,String workshopId) async {
//     try {
//       final jsonData = await _repo.getBookingStateJson(userId ,workshopId);
//       if (jsonData != null &&
//           jsonData['workshopId'] == workshopId &&
//           jsonData['isBooked'] == true) {
//         emit(BookingSuccess(workshopId, isBooked: true));
//       } else {
//         // الحالة الافتراضية: لم يتم الحجز
//         emit(BookingSuccess(workshopId, isBooked: false));
//       }
//     } catch (e) {
//       emit(BookingError(errMsg: e.toString()));
//     }
//   }
//    Future<void> makeBooking(AppointmentModel booking) async {
//     try {
//       emit(BookingLoading());
//       await _repo.addBooking(booking);
//       // تأكيد إنه تم حجز الورشة
//       await _repo.saveBookingState(booking.userId,booking.workshopId, true);
//
//       // طباعة للتصحيح
//       print("Booked workshop ${booking.workshopId}");
//       emit(BookingSuccess( booking.workshopId ,isBooked: true,));
//        } catch (e) {
//       emit(BookingError(errMsg: e.toString()));
//     }
//   }
//
//    // حجز الورشة باستخدام// AppointmentModel (باستخدام SharedPreferences)
//   Future<void> bookWorkshop(AppointmentModel booking) async {
//     try {
//       emit(BookingLoading());
//       await _repo.addBooking(booking);
//       await _repo.saveBookingState(booking.userId,booking.workshopId, true);
//       print("Booked workshop ${booking.workshopId}");
//       emit(BookingSuccess( booking.workshopId, isBooked: true));
//     } catch (e) {
//       emit(BookingError(errMsg: e.toString()));
//     }
//    }
//
//    // إلغاء حجز ورشة معينة
//   Future<void> unbookWorkshop(String userId,String workshopId) async {
//     try {
//       emit(BookingLoading());
//       await _repo.saveBookingState(userId,workshopId, false);
//       print("Unbooked workshop $workshopId");
//       emit(BookingSuccess(workshopId, isBooked: false));
//     } catch (e) {
//       print("Error unbooking: $e");
//       emit(BookingError(errMsg: e.toString()));
//     }
//   }
//   ////////////////////////  shared
//
//
//  refreshWorkshop(){
//     emit(WorkshopsRefresh());
//  }
//   // Future<void> makeBooking(AppointmentModel booking) async {
//   //   try {
//   //     emit(BookingLoading());
//   //     await _repo.addBooking(booking);
//   //     await _repo.saveBookingStateFirebase(booking.workshopId, true, booking.userId);
//   //     emit(BookingSuccess(isBooked: true,booking.workshopId));
//   //   } catch (e) {
//   //     emit(BookingError(errMsg: e.toString()));
//   //   }
//   // }
//
//   Future<void> saveBookingState(String workshopId, bool isBooked) async {
//     try {
//       emit(BookingLoading());
//
//       final userId = FirebaseAuth.instance.currentUser!.uid;
//       await _repo.saveBookingStateFirebase(workshopId, isBooked, userId);
//
//       // أضف هذا الجزء لحفظ الحالة محلياً
//       final prefs = await SharedPreferences.getInstance();
//       List<String> booked = prefs.getStringList('booked_workshops') ?? [];
//
//       if (isBooked) {
//         if (!booked.contains(workshopId)) booked.add(workshopId);
//       } else {
//         booked.remove(workshopId);
//       }
//
//       await prefs.setStringList('booked_workshops', booked);
//
//       emit(BookingSuccess(isBooked: isBooked,workshopId));
//     } catch (e) {
//       emit(BookingError(errMsg: e.toString()));
//     }
//   }
//
//
//   Future<void> loadBookingState(String workshopId) async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser!.uid;
//       final bookingData = await _repo.getBookingState(workshopId, userId);
//       final isBooked = bookingData?['isBooked'] ?? false;
//       emit(BookingSuccess(isBooked: isBooked,workshopId));
//     } catch (e) {
//       emit(BookingError(errMsg: e.toString()));
//     }
//   }
//
//   Future<void> cancelBooking(String workshopId) async {
//     try {
//       emit(BookingLoading());
//
//       final userId = FirebaseAuth.instance.currentUser!.uid;
//       await _repo.cancelBooking(workshopId, userId);
//
//       // احذف الورشة من SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       List<String> booked = prefs.getStringList('booked_workshops') ?? [];
//       booked.remove(workshopId);
//       await prefs.setStringList('booked_workshops', booked);
//
//       emit(BookingSuccess(isBooked: false,workshopId));
//     } catch (e) {
//       emit(BookingError(errMsg: e.toString()));
//     }
//   }
//
//
//   Future<void> checkIfWorkshopBooked(String workshopId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final bookedWorkshops = prefs.getStringList('booked_workshops') ?? [];
//       final isBooked = bookedWorkshops.contains(workshopId);
//       emit(BookingStatusChecked(isBooked));
//     } catch (e) {
//       emit(BookingError(errMsg: e.toString()));
//     }
//   }
//
//
//
// }

class WorkshopsCubit extends Cubit<WorkshopsState> {
  WorkshopsCubit(this._repo) : super(WorkshopsInitial());
  final fcmService = FCMService();

  final WorkshopRepository _repo;

  bool isWorkshopOpen(String startTimeStr, String endTimeStr) {
    try {
      final now = DateTime.now();
      final format = DateFormat('hh:mm a'); // مثال: 08:30 AM

      final startTime = format.parse(startTimeStr);
      final endTime = format.parse(endTimeStr);

      // بنضيف التاريخ الحالي علشان نقدر نقارن صح
      final startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        startTime.hour,
        startTime.minute,
      );
      final endDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        endTime.hour,
        endTime.minute,
      );
      final currentTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );

      return currentTime.isAfter(startDateTime) &&
          currentTime.isBefore(endDateTime);
    } catch (e) {
      print('Error parsing time: $e');
      return false;
    }
  }

  /// جلب الورش
  Future<void> fetchAllWorkshops() async {
    emit(GetAllWorkshopsLoading());
    try {
      final workshops = await _repo.getAllWorkshops();
      emit(GetAllWorkshopsSuccess(list: workshops));
    } catch (e) {
      emit(GetAllWorkshopsError(errMsg: e.toString()));
    }
  }

  Future<void> fetchWorkshops() async {
    emit(GetAllWorkshopsLoading());
    try {
      final workshops = await _repo.getAllWorkshops();

      // فلترة الورش المفتوحة فقط
      final openWorkshops =
          workshops.where((w) {
            final start = w.startTime ?? '';
            final end = w.endTime ?? '';
            return isWorkshopOpen(start, end);
          }).toList();

      emit(GetWorkshopsSuccess(list: openWorkshops));
    } catch (e) {
      emit(GetWorkshopsError(errMsg: e.toString()));
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // عمل حجز
  Future<void> makeBooking(AppointmentModel booking) async {
    try {
      emit(BookingLoading());
      print(
        "Making booking for workshop: ${booking.workshopId}, user: ${booking.userId}",
      );

      // Check if user already has a booking (any workshop)
      final userBookings =
          await FirebaseFirestore.instance
              .collection('bookings')
              .where(
                'userId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .get();

      if (userBookings.docs.isNotEmpty) {
        emit(
          BookingError(
            errMsg:
                "You already have an active booking. Please cancel it first.",
          ),
        );
        return;
      }

      // Check if user already booked this specific workshop
      final workshopBookings =
          await FirebaseFirestore.instance
              .collection('bookings')
              .where(
                'userId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .where('workshopId', isEqualTo: booking.workshopId)
              .get();
      if (workshopBookings.docs.isNotEmpty) {
        emit(BookingError(errMsg: "You already booked this workshop."));
        return;
      }

      // Save the booking with a unique ID
      final bookingId = const Uuid().v4(); // Generate unique ID
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set(booking.copyWith(id: bookingId).toJson());

      await saveBookingState(booking.workshopId, true);
      print(
        "Booking saved to Firestore and SharedPreferences with ID: $bookingId",
      );
      // final workshopDoc =
      //     await FirebaseFirestore.instance
      //         .collection('workshops')
      //         .doc(booking.workshopId)
      //         .get();

      //final fcmToken = workshopDoc.data()?['fcmToken'];

      // if (fcmToken != null) {
      //   await PushNotificationService.sendPushMessage(
      //     targetToken: fcmToken,
      //     title: '📢 تم حجز جديد',
      //     body:
      //         'قام ${booking.clientName}. بحجز موعد بتاريخ ${DateTime.now().toLocal()}',
      //   );
      // }

      emit(BookingSuccess(booking.workshopId, isBooked: true));
      // 2️⃣ إرسال الإشعار للورشة مباشرة
      await NotificationService().sendNotification(
        targetUserId: booking.workshopId,
        title: 'تم الحجز',
        body: ' لديك حجز ورشه جديد!',
        route:Routes.splash,
      );

      print("✅ تم إرسال الإشعار للورشة بنجاح");
    } catch (e) {
      print("Booking error: $e");
      emit(BookingError(errMsg: e.toString()));
    }
  }



  Future<void> cancelBooking(String bookingId, String workshopId) async {
    try {
      emit(BookingLoading());
      print("Canceling booking with ID: $bookingId for workshop: $workshopId");

      // Verify booking exists and belongs to the user
      final bookingDoc =
          await FirebaseFirestore.instance
              .collection('bookings')
              .doc(bookingId)
              .get();
      if (!bookingDoc.exists ||
          bookingDoc.data()!['userId'] !=
              FirebaseAuth.instance.currentUser!.uid) {
        emit(
          BookingError(
            errMsg:
                "No booking found or you don't have permission to cancel it.",
          ),
        );
        return;
      }

      // Delete the booking
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .delete();

      await saveBookingState(workshopId, false);
      print("Booking canceled");
      emit(BookingSuccess(workshopId, isBooked: false));
    } catch (e) {
      print("Cancel error: $e");
      emit(BookingError(errMsg: e.toString()));
    }
  }

  Future<void> saveBookingState(String workshopId, bool isBooked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('booking_$workshopId', isBooked);
    print("Saved booking state for $workshopId: $isBooked");
  }

  Future<void> checkIfWorkshopBooked(String workshopId) async {
    try {
      emit(BookingLoading());
      final prefs = await SharedPreferences.getInstance();
      bool localBooked = prefs.getBool('booking_$workshopId') ?? false;

      final doc =
          await FirebaseFirestore.instance
              .collection('bookings')
              .where(
                'userId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .where('workshopId', isEqualTo: workshopId)
              .get();

      bool firebaseBooked = doc.docs.isNotEmpty;
      print("Checked booking: Local=$localBooked, Firebase=$firebaseBooked");

      emit(BookingStatusChecked(firebaseBooked || localBooked));
    } catch (e) {
      print("Check booking error: $e");
      emit(BookingError(errMsg: e.toString()));
    }
  }

  /// إعادة تحميل واجهة الورش
  ///
  ///
  ///
  ///

  Future<void> bookWorkshopWithDetails(AppointmentModel workshop) async {
    emit(WorkshopBookingLoading());

    try {
      final workshopId = workshop.id;

      // 1. Check if workshop exists
      DocumentSnapshot workshopDoc =
          await _firestore.collection('workshops').doc(workshopId).get();

      // 2. Get current user ID
      final customerId = _firebaseAuth.currentUser?.uid;
      if (customerId == null) {
        emit(WorkshopBookingError("يجب تسجيل الدخول أولاً"));
        return;
      }

      List<dynamic>? existingBookings;
      if (workshopDoc.exists &&
          (workshopDoc.data() as Map<String, dynamic>).containsKey(
            'bookingsWorkshop',
          )) {
        existingBookings =
            workshopDoc.get('bookingsWorkshop') as List<dynamic>?;
      } else {
        existingBookings = [];
      }

      if (existingBookings!.contains(customerId)) {
        emit(WorkshopBookingError("لقد قمت بحجز هذه الورشة مسبقاً"));
        return;
      }

      // 3. Add booking + save workshop details
      await _firestore.collection('workshopBookings').doc(workshopId).set({
        'workshopData': workshop.toJson(),
        // 👈 حفظ تفاصيل الورشة بالكامل
        'bookingsWorkshop': FieldValue.arrayUnion([customerId]),
        // 👈 إضافة الحاجز
      }, SetOptions(merge: true));

      emit(WorkshopBookingSuccess());
    } on FirebaseException catch (e) {
      emit(WorkshopBookingError(e.message ?? "حدث خطأ أثناء الحجز"));
    } catch (e) {
      emit(WorkshopBookingError("حدث خطأ غير متوقع: $e"));
    }
  }

  void refreshWorkshop() {
    emit(WorkshopsRefresh());
  }

  /////////////////////////////////////////////
  Future<void> addReview({
    required String productId,
    required String userId,
    required double rating,
    // required String nameClient,
    required String comment,
  }) async {
    try {
      emit(ReviewLoading());
      final reviewRef = FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(productId)
          .collection('reviews')
          .doc(userId); // يجعل كل مستخدم يمكنه يضيف تقييم واحد فقط.

      await reviewRef.set({
        'userId': userId,
        'rating': rating,
        'nameClient': SharedPrefHelper.getString("userName"),
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(ReviewSuccess());
      getReviews(productId);
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
  final firestore = FirebaseFirestore.instance;

  // void getPeople(String workshopId) {
  //   emit(MechanicalLoading());
  //
  //   firestore.collection(workshopId).snapshots().listen((snapshot) {
  //     final people = snapshot.docs.map((doc) => doc['name'] as String).toList();
  //     emit(MechanicalLoaded(people));
  //   }, onError: (error) {
  //     emit(MechanicalError(error.toString()));
  //   });
  // }
  void getPeople(String workshopId) {
    emit(MechanicalLoading());

    firestore
        .collection("mechanicals")
        .doc(workshopId)
        .collection('mechanics') // لو Subcollection اسمها mechanics
        .snapshots()
        .listen((snapshot) {
      final people = snapshot.docs.map((doc) => doc['name'] as String).toList();
      emit(MechanicalLoaded(people));
    });
  }



  Future<void> getReviews(String productId) async {
    try {
      emit(ReviewLoading());
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection(usersCollection)
              .doc(productId)
              .collection('reviews')
              .orderBy('timestamp', descending: true)
              .get();

      final reviews =
          querySnapshot.docs.map((doc) {
            return ReviewModel.fromMap(doc.data(), doc.id);
          }).toList();

      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
