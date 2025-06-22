import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';

class WorkshopHomeRepo {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  // Future<void> addPerson(String name) async {
  //   await firestore.collection(mechanicNameCollection).add({
  //     'name': name,
  //     'workshopId':userId,
  //   });
  // }
  Future<void> addPerson(String name) async {
    await firestore.collection("mechanicals").doc(userId).collection("mechanics").add({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //
  // Stream<List<String>> getPeople() {
  //   return firestore.collection(mechanicNameCollection).snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => doc['name'] as String).toList();
  //   });
  // }
  Stream<List<String>> getPeople() {

    if (userId == null) {
      // لو مفيش مستخدم، نرجع Stream فاضي.
      return Stream.value([]);
    }

    return firestore.collection("mechanicals").doc(userId).collection("mechanics").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }



  Future<void> deletePersonByName(String name) async {
    final querySnapshot = await firestore
        .collection(userId)
        .where('name', isEqualTo: name)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }




}

