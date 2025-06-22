import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';

class RepoManager {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future createAccount({
    required String email,
    required String password,
  }) async {
   return  await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  saveDataUser({
    required String userName,
    required String email,
    required String phone,
    required String password,
    required String userType,
    required String uid,
  }) async {
    await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uid)
        .set({
      "userType":userType,
      "userName":userName,
      "email":email,
      "phone":phone,
      "profileImage":"",
      "uid":uid


    });
  }

  Future loginUser({required String email , required String password})async{
    return await auth.signInWithEmailAndPassword(email: email, password: password);
  }

}
