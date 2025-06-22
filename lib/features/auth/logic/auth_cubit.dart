import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/auth/data/repo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'auth_state.dart';

enum UserType { client, workshop }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repo) : super(AuthInitial());

  final RepoManager repo;

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();
  GlobalKey loginFormKey = GlobalKey<FormState>();

  String _userType = 'client';

  void setUserType(String type) {
    _userType = type.toLowerCase();
    print("UserType set to: $_userType");
    emit(AuthUserTypeSelected(_userType));
  }

  String get userType => _userType;

  Future<void> checkAuthStatus() async {
    emit(SignUpLoading());
    User? user = await repo.getCurrentUser();
    // if (user != null) {
    //   emit(SignUpSuccess(user));
    // } else {
    //   emit(SignUpFailure(userType));
    // }
  }

  ///////////////  sign up ///////////
  signUp({required String usertype}) async {
    emit(SignUpLoading());
    try {
      var userCredential = await repo.createAccount(
        email: emailController.text,
        password: passwordController.text,
      );

      repo.saveDataUser(
        userName: userNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        userType: usertype,
        uid: userCredential.user!.uid,
      );
      emit(SignUpSuccess(userCredential.user));

      userNameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpFailure(errorMsg: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(
          SignUpFailure(errorMsg: 'The account already exists for that email.'),
        );
      } else if (e.code == 'invalid-phone-number') {
        emit(SignUpFailure(errorMsg: 'The phone number format is invalid.'));
      } else if (e.code == 'phone-number-already-exists') {
        emit(
          SignUpFailure(errorMsg: 'This phone number is already registered.'),
        );
      } else {
        emit(
          SignUpFailure(errorMsg: 'An unexpected error occurred: ${e.message}'),
        );
      }
    } on Exception catch (e) {
      emit(SignUpFailure(errorMsg: e.toString()));
    }
  }

  ///////////////////// login /////////////
  SignIn() async {
    emit(LoginLoading());
    try {
      var userCredential = await repo.loginUser(
        email: emailController.text,
        password: passwordController.text,
      );
      String uid = userCredential.user!.uid;
      var userDoc =
          await FirebaseFirestore.instance
              .collection(usersCollection)
              .doc(uid)
              .get();

      if (!userDoc.exists) {
        emit(LoginFailure(errorMsg: 'User data not found in Firestore.'));
        return;
      }

      // 🔹 استخراج الـ userType
      String userType = userDoc.data()?['userType'] ?? '';

      if (userType.isEmpty) {
        emit(LoginFailure(errorMsg: 'UserType is missing in Firestore.'));
        return;
      }

      print("✅ UserType from Firestore: $userType");
      emit(LoginSuccess(userCredential.user, userType));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errorMsg: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errorMsg: 'Wrong password provided.'));
      } else {
        emit(
          LoginFailure(errorMsg: 'An unexpected error occurred: ${e.message}'),
        );
      }
    } on Exception catch (e) {
      emit(LoginFailure(errorMsg: e.toString()));
    }
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return emit(AuthFailure("تم إلغاء تسجيل الدخول"));

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      repo.saveDataUser(
        userName: userNameController.text,
        email:userCred.user!.email! ,
        phone: phoneController.text,
        password: passwordController.text,
        userType: _userType,
        uid: userCred.user!.uid,
      );
      emit(AuthSuccess(userCred.user!,_userType));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Future<void> signInWithFacebook() async {
  //   emit(AuthLoading());
  //   try {
  //     final result = await FacebookAuth.instance.login();
  //     if (result.status != LoginStatus.success) {
  //       return emit(AuthFailure("فشل تسجيل الدخول بـ Facebook"));
  //     }
  //
  //     final facebookCredential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
  //     final userCred = await _auth.signInWithCredential(facebookCredential);
  //     emit(AuthSuccess(userCred.user!,_userType));
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }
  Future<void> signInWithFacebook() async {
    emit(AuthLoading());
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        return emit(AuthFailure("فشل تسجيل الدخول بـ Facebook"));
      }

      final facebookCredential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
      final userCred = await _auth.signInWithCredential(facebookCredential);
      final user = userCred.user;

      if (user != null) {
        // ✅ حفظ البيانات في Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'userName': user.displayName ?? '',
          'email': user.email ?? '',
          'provider': 'facebook',
          "phone":"",
          "userType":_userType,
          'profileImage': user.photoURL ?? '',
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      emit(AuthSuccess(user!, _userType));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

}
