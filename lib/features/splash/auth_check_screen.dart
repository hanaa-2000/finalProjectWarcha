import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/features/auth/converts_screen.dart';
import 'package:warcha_final_progect/features/auth/ui/login/screen/login_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/home_client_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/main_home_screen.dart';
import 'package:warcha_final_progect/features/onbording/onbording_screen.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/home_workshop_screen.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/main_workshop_screen.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // تأخير بسيط لضمان تثبيت الواجهة (اختياري)
    await Future.delayed(const Duration(milliseconds: 500));

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(user.uid)
            .get();

        String userType = '';
        if (userDoc.exists) {
          userType = (userDoc.data() as Map<String, dynamic>)['userType'] ?? '';
          print("✅ UserType from Firestore: $userType");
        }

        if (userType.toLowerCase() == 'client') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainHomeClientScreen()),
          );
        } else if (userType.toLowerCase() == 'workshop') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainWorkshopScreen()),
          );
        } else {
          print("lllllllll");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } catch (e) {
        print("❌ Error retrieving userType: $e");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ConvertsScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConvertsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // شاشة تحميل بسيطة أثناء التحقق
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: ColorApp.mainApp,)),
    );
  }
}