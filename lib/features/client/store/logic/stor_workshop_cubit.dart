import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/core/notification/service_notification.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/features/client/home/data/reviwes_model.dart';
import 'package:warcha_final_progect/features/client/store/data/accessories_model.dart';
import 'package:warcha_final_progect/features/client/store/data/store_client_repo.dart';

part 'stor_workshop_state.dart';

class StorWorkshopCubit extends Cubit<StorWorkshopState> {
  StorWorkshopCubit(this.repo) : super(StorWorkshopInitial());

  final StoreClientRepo repo ;
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void fetchProducts() {
    emit(GetAccessoriesLoading());
    try{
      repo.getProducts().listen((products) {
        emit(GetAccessoriesSuccess(list: products));
      });
    }on FirebaseException catch(e){
      emit(GetAccessoriesFailure(errorMsg: e.toString()));
    }
  }

  refreshData(){
    emit(RefreshData());
    //fetchProducts();
  }

  Future<void> loadProductWithBookingStatus(String productId) async {
    emit(ProductBookingLoading());  // حالة التحميل

    try {
      // تحميل بيانات المنتج من Firestore
      DocumentSnapshot productDoc = await _firestore.collection(productCollection).doc(productId).get();
      if (!productDoc.exists) {
        emit(ProductBookingError("هذا المنتج غير موجود"));
        return;
      }

      // الحصول على customerId الحالي
      final customerId = FirebaseAuth.instance.currentUser?.uid;
      if (customerId == null) {
        emit(ProductBookingError("يجب تسجيل الدخول أولاً"));
        return;
      }

      // التحقق إذا كان المستخدم قد حجز المنتج
      List<dynamic> bookingsProduct = productDoc.get('bookedBy') ?? [];
      bool isBooked = bookingsProduct.any((booking) => booking['customerId'] == customerId);

      // تحديث حالة الحجز في الـ Cubit
      emit(ProductBookingState(isBooking: isBooked, productId: productId));
    } catch (e) {
      emit(ProductBookingError("حدث خطأ أثناء تحميل البيانات"));
    }
  }

  // عملية الحجز
  Future<void> bookProduct(AccessoriesModel product, String productId) async {
    emit(ProductBookingLoading());

    try {
      // 1. Check if the product exists
      DocumentSnapshot productDoc = await _firestore.collection(productCollection).doc(productId).get();
      if (!productDoc.exists) {
        emit(ProductBookingError("هذا المنتج غير موجود"));
        return;
      }

      // 2. Get current user ID
      final customerId = _firebaseAuth.currentUser?.uid;
      if (customerId == null) {
        emit(ProductBookingError("يجب تسجيل الدخول أولاً"));
        return;
      }

      // 3. Check for duplicate booking safely
      List<dynamic>? existingBookings;
      if (productDoc.data() != null && (productDoc.data() as Map<String, dynamic>).containsKey('bookedBy')) {
        existingBookings = productDoc.get('bookedBy') as List<dynamic>?;
      } else {
        existingBookings = [];
      }

      if (existingBookings!.contains(customerId)) {
        emit(ProductBookingError("لقد قمت بحجز هذا المنتج مسبقاً"));
        return;
      }

      final clientName = await SharedPrefHelper.getString("userName");
      final clientPhone = await SharedPrefHelper.getString("phone");

      // 4. Add booking safely with merge
      await _firestore.collection(productCollection).doc(productId).set({
        'bookedBy': FieldValue.arrayUnion([customerId,clientName,clientPhone]), // Add only the customerId here
      }, SetOptions(merge: true));

      emit(ProductBookingSuccess());
// 2️⃣ إرسال الإشعار للورشة مباشرة
      await NotificationService().sendNotification(
        targetUserId: product.workshopId,
        title: 'تم الحجز',
        body: ' لديك حجز منتج جديد!',
        route:Routes.splash,
      );

    } on FirebaseException catch (e) {
      emit(ProductBookingError(e.message ?? "حدث خطأ أثناء الحجز"));
    } catch (e) {
      emit(ProductBookingError("حدث خطأ غير متوقع: $e"));
    }
  }





  Future<void> cancelBooking(String productId) async {
    emit(ProductBookingLoading());

    try {
      // 1. تأكد إن المنتج موجود
      DocumentSnapshot productDoc = await _firestore.collection(productCollection).doc(productId).get();
      if (!productDoc.exists) {
        emit(ProductBookingError("هذا المنتج غير موجود"));
        return;
      }

      // 2. احصل على ID المستخدم الحالي
      final customerId = _firebaseAuth.currentUser?.uid;
      if (customerId == null) {
        emit(ProductBookingError("يجب تسجيل الدخول أولاً"));
        return;
      }

      // 3. شيل الـ customerId من قائمة الحاجزين
      await _firestore.collection(productCollection).doc(productId).set({
        'bookedBy': FieldValue.arrayRemove([customerId]),
      }, SetOptions(merge: true));

      emit(ProductCancelBookingSuccess());

    } on FirebaseException catch (e) {
      emit(ProductBookingError(e.message ?? "حدث خطأ أثناء إلغاء الحجز"));
    } catch (e) {
      emit(ProductBookingError("حدث خطأ غير متوقع: $e"));
    }
  }

  /////////////////////////////////////////////
  Future<void> addReview({
    required String productId,
    required double rating,

  }) async {
    final userId =FirebaseAuth.instance.currentUser!.uid;
    try {
      emit(ReviewLoading());
      final reviewRef = FirebaseFirestore.instance
          .collection(productCollection)
          .doc(productId)
          .collection('reviews')
          .doc(userId); // يجعل كل مستخدم يمكنه يضيف تقييم واحد فقط.

      await reviewRef.set({
        'userId': userId,
        'rating': rating,
        'nameClient': SharedPrefHelper.getString("userName"),
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(ReviewSuccess());
      getReviews(productId);
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> getReviews(String productId) async {
    try {
      emit(ReviewLoading());
      final querySnapshot =
      await FirebaseFirestore.instance
          .collection(productCollection)
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


