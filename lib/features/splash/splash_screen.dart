import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:warcha_final_progect/core/networking/constants.dart';
import 'package:warcha_final_progect/features/client/home/ui/home_client_screen.dart';
import 'package:warcha_final_progect/features/onbording/onbording_screen.dart';
import 'package:warcha_final_progect/features/splash/auth_check_screen.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/home_workshop_screen.dart';

import '../../core/routing/routes.dart';
import '../auth/ui/login/screen/login_screen.dart';

class SplashScreen  extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Timer? _timer;
  // navigateScreen() {
  //   _timer=Timer(
  //     const Duration(seconds: 15),
  //         () {
  //       FirebaseAuth.instance.authStateChanges().listen((User ? user) {
  //         if(mounted){
  //           if(user == null){
  //             Navigator.of(context).pushReplacement(
  //                 MaterialPageRoute(builder: (context) => const OnboardingScreen()));
  //           }else{
  //             Navigator.of(context).pushReplacement(
  //                 MaterialPageRoute(builder: (context) => const Home()));
  //           }
  //         }
  //       }
  //       );
  //
  //
  //     },
  //   );
  // }

  // @override
  // void initState() {
  //   _checkAuth();
  //   super.initState();
  // }
  //
  // Future<void> _checkAuth() async {
  //   // تأخير بسيط لضمان تثبيت الواجهة (اختياري)
  //   await Future.delayed(const Duration(milliseconds: 500));
  //
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     try {
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection(usersCollection)
  //           .doc(user.uid)
  //           .get();
  //
  //       String userType = '';
  //       if (userDoc.exists) {
  //         userType = (userDoc.data() as Map<String, dynamic>)['userType'] ?? '';
  //         print("✅ UserType from Firestore: $userType");
  //       }
  //
  //       if (userType.toLowerCase() == 'client') {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => const HomeClientScreen()),
  //         );
  //       } else if (userType.toLowerCase() == 'workshop') {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => const HomeWorkshopScreen()),
  //         );
  //       } else {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => const OnboardingScreen()),
  //         );
  //       }
  //     } catch (e) {
  //       print("❌ Error retrieving userType: $e");
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
  //       );
  //     }
  //   } else {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const LoginScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          const Spacer(),
          Image.asset(
            "assets/images/logo.png",
           // width: MediaQuery.sizeOf(context).width /.5,
          ),
          // Image.asset(
          //   "assets/images/splash.png",
          // ),
          const Spacer(),
        ],
      ),
      splashIconSize: MediaQuery.sizeOf(context).width,
      duration: 1000,
      backgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 1500),
      nextScreen: const OnboardingScreen(),
      splashTransition: SplashTransition.scaleTransition,
     nextRoute: Routes.onbording,

    );
  }
}
