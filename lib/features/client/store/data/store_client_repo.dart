import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/client/store/data/accessories_model.dart';
import 'package:warcha_final_progect/features/client/store/data/accessories_order_moadel.dart';

class StoreClientRepo {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Stream<List<AccessoriesModel>> getProducts() {
    return _firestore.collection(productCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AccessoriesModel.fromDocument(doc, doc.id)).toList();
    });
  }



  Future<void> addBookingAccessories(AccessoriesOrderModel booking) async {
    await _firestore.collection(accessoriesOrderCollection).doc(booking.id).set(booking.toJson());
  }




}