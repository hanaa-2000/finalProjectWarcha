
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:warcha_final_progect/core/widgets/drawer_body.dart';
import 'package:warcha_final_progect/features/workshop/home/data/workshop_home_repo.dart';
import 'package:warcha_final_progect/features/workshop/home/logic/workshop_home_cubit.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/widgets/workshop_home_body.dart';

class HomeWorkshopScreen extends StatefulWidget {
  const HomeWorkshopScreen({super.key});

  @override
  State<HomeWorkshopScreen> createState() => _HomeWorkshopScreenState();
}

class _HomeWorkshopScreenState extends State<HomeWorkshopScreen> {

// late WorkshopHomeCubit _personCubit;
@override
  void initState() {
  // BlocProvider.of<WorkshopHomeCubit>(context).getPeople();
  // BlocProvider.of<WorkshopHomeCubit>(context).loadSelectedNames();
  // BlocProvider.of<WorkshopHomeCubit>(context).selectedNames;
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      saveFcmToken(userId);
    }
  }
Future<void> saveFcmToken(String userId) async {
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'fcm_token': token,
    }, SetOptions(merge: true));
    print('✅ تم حفظ FCM Token للمستخدم: $userId');
  } else {
    print('❌ لم يتم الحصول على FCM Token');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: BlocProvider(
        create: (context) => WorkshopHomeCubit(WorkshopHomeRepo())..getPeople()..loadSelectedNames(),
        child: Drawer(
          backgroundColor: Colors.white,
          child: DrawerBody(),
        ),
      ),
      body: WorkshopHomeBody(),

    );
  }

}
