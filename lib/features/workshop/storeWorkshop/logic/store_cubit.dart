import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/data/product_model.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/data/store_repo.dart';

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  StoreCubit(this.productRepository) : super(StoreInitial());

  final StoreRepo productRepository;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(
      String companyName,
      String countryManufacture,
      String specifications,
      String yearManufacture,
      String price,
      String imagePath,
      ) async {
    emit(ProductLoading());
    try {
      // رفع الصورة إلى Firebase
      // var ref = storage.ref().child('product_images/${DateTime.now()}.png');
      // await ref.putFile(File(imagePath));
      // String imageUrl = await ref.getDownloadURL();
      Reference ref = FirebaseStorage.instance.ref().child("profile_images/${DateTime.now()}.jpg");

      UploadTask uploadTask = ref.putFile(File(imagePath));
      await uploadTask;
      TaskSnapshot snapshot = await uploadTask;

      String downloadURL = await snapshot.ref.getDownloadURL();
      // إنشاء معرّف فريد للمنتج
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      ProductModel product = ProductModel(
          image: downloadURL,
          companyName: companyName,
          specifications: specifications,
          countryManufacture: countryManufacture,
          yearManufacture: yearManufacture,
          price: price,
          id: id,


      );

      // إضافة المنتج إلى Firebase
      await productRepository.addProduct(product);
      emit(ProductSuccess());
    } catch (e) {
      emit(ProductFailure(errorMsg: e.toString()));
    }
  }

  Future<void> deleteProduct(String productId) async {
    emit(ProductLoading());
    try {
      await productRepository.deleteProduct(productId);
      emit(ProductDeleted());
    } catch (e) {
      emit(ProductFailure(errorMsg: e.toString()));
    }
  }

  void fetchProducts( )async {
    final userId = await FirebaseAuth.instance.currentUser!.uid;

    emit(GetProductsLoading());
    try{
      productRepository.getProductsForWorkshop(userId).listen((products) {
        emit(GetProductsSuccess(list: products));
      });
    }on FirebaseException catch(e){
      emit(GetProductsFailure(errorMsg: e.toString()));
    }
    }

  Future<void> fetchProductsForWorkshop() async {
    emit(ProductBookingLoading());
  final workshopId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .where('workshopId', isEqualTo: workshopId)
          .get();

      List<ProductModel> products = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        if (data.containsKey('bookedBy') && (data['bookedBy'] as List).isNotEmpty) {
          List<dynamic> rawBookings = data['bookedBy'];

          List<BookingModel> bookings = [];
          for (var i = 0; i < rawBookings.length; i += 3) {
            if (i + 2 < rawBookings.length) {
              bookings.add(BookingModel(
                customerId: rawBookings[i],
                clientName: rawBookings[i + 1],
                clientPhone: rawBookings[i + 2],
              ));
            }
          }

          products.add(ProductModel(
            image: data['image'],
            companyName: data['companyName'],
            specifications: data['specifications'],
            countryManufacture: data['countryManufacture'],
            yearManufacture: data['yearManufacture'],
            price: data['price'],
            id: doc.id,
            bookingModel: bookings,
          ));
        }
      }

      emit(ProductBookingSuccess(products));
    } catch (e) {
      emit(ProductBookingError('خطأ أثناء جلب البيانات: $e'));
    }
  }




}
