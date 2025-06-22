import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/data/product_model.dart';

class StoreRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  // SharedPreferences prefs =prefs await SharedPreferences.getInstance();
  // رفع المنتج إلى Firebase
  // Future<void> addProduct(ProductModel product) async {
  //   await _firestore.collection(productCollection).doc(product.id).set(product.toJson());
  // }

  Future<void> addProduct(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await FirebaseAuth.instance.currentUser!.uid;
    // جلب البيانات من SharedPreferences
    String? name = prefs.getString('name');
    String? phone = prefs.getString('phone');
    String? location = prefs.getString('location');
    String? longitude = prefs.getString('longitude');
    String? latitude = prefs.getString('latitude');

    // تحويل بيانات المنتج إلى Map
    Map<String, dynamic> productData = product.toJson();

    // دمج بيانات SharedPreferences
    productData.addAll({
      'userName': name,
      'phone': phone,
      'location': location,
      'longitude': longitude,
      'latitude': latitude,
      'workshopId':userId,
    });

    // رفع البيانات إلى Firebase
    await _firestore.collection(productCollection).doc(product.id).set(productData);
  }


  // حذف المنتج من Firebase
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection(productCollection).doc(productId).delete();
  }

  // Stream<List<ProductModel>> getProducts() {
  //   return _firestore.collection(productCollection).snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => ProductModel.fromDocument(doc)).toList();
  //   });
  // }
  Stream<List<ProductModel>> getProductsForWorkshop(String workshopId) {
    return _firestore
        .collection(productCollection)
        .where('workshopId', isEqualTo: workshopId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromDocument(doc)).toList();
    });
  }


}