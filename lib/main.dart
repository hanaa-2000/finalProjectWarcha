import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcha_final_progect/core/notification/push_notification_service.dart';
import 'package:warcha_final_progect/core/notification/service_notification.dart';
import 'package:warcha_final_progect/core/routing/app_routing.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:warcha_final_progect/features/auth/data/repo.dart';
import 'package:warcha_final_progect/features/auth/logic/auth_cubit.dart';
import 'package:warcha_final_progect/features/client/favorite/logic/favorite_cubit.dart';
import 'package:warcha_final_progect/features/client/home/data/workshop_repo.dart';
import 'package:warcha_final_progect/features/client/home/logic/search/search_cubit.dart';
import 'package:warcha_final_progect/features/client/home/logic/workshops_cubit.dart';
import 'package:warcha_final_progect/features/client/profile/data/profile_repo.dart';
import 'package:warcha_final_progect/features/client/profile/logic/profile_client_cubit.dart';
import 'package:warcha_final_progect/features/client/store/data/store_client_repo.dart';
import 'package:warcha_final_progect/features/client/store/logic/stor_workshop_cubit.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/manager/strip_payment_cubit.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/repo/checkout_repo_implement.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/services/api_keys.dart';
import 'package:warcha_final_progect/features/workshop/home/data/workshop_home_repo.dart';
import 'package:warcha_final_progect/features/workshop/home/logic/workshop_home_cubit.dart';
import 'package:warcha_final_progect/features/workshop/profile/data/repo/profile_repo.dart';
import 'package:warcha_final_progect/features/workshop/profile/logic/profile_cubit.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/data/store_repo.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/logic/store_cubit.dart';
import 'firebase_options.dart';


final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = ApiKeys.publishKey;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey: 'your-site-key', // مطلوب فقط للويب
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  final user = FirebaseAuth.instance.currentUser;
  // final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  // if (initialMessage != null && initialMessage.data['route'] != null) {
  //   navigatorKey.currentState?.pushNamed(initialMessage.data['route']);
  // }
 // 👇 لازم تطلب الإذن قبل عرض أي إشعار

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
  );
  print('🔐 Notification permission status: ${settings.authorizationStatus}');
  if (user != null) {
    await NotificationService().init(
      currentUserId: user.uid,
      serviceAccountAssetPath: 'assets/fcm_service_account.json',
      navigatorKey: navigatorKey,

    );

  }
  // FirebaseMessaging.instance.getInitialMessage().then((message) {
  //   if (message != null && message.data['route'] != null) {
  //     final route = message.data['route'];
  //     print('🧭 فتح من إشعار (terminated) ➜ $route');
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       navigatorKey.currentState?.pushNamed(route);
  //     });
  //   }
  // });

  runApp(MyApp(appRouting: AppRouting(),));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data['route'] != null) {
        final route = message.data['route'];
        print('🧭 فتح من إشعار (terminated) ➜ $route');
        navigatorKey.currentState?.pushNamed(route);
      }
    });
  });

}
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final AppRouting appRouting;

   const MyApp({super.key, required this.appRouting, });

  // final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(RepoManager())),
        ///////////////////////////////////  workshops
        BlocProvider(
          create: (context) => ProfileCubit(ProfileRepo())..fetchUserProfile(),
        ),

        BlocProvider(create: (context) => StoreCubit(StoreRepo())),
        BlocProvider(
          create:
              (context) => WorkshopHomeCubit(WorkshopHomeRepo())..getPeople(),
        ),

        //////////////////////////////  client
        BlocProvider(
          create:
              (context) =>
                  WorkshopsCubit(WorkshopRepository())..fetchWorkshops(),
        ),
        BlocProvider(create: (context) => StorWorkshopCubit(StoreClientRepo())..fetchProducts(),
        ),
        BlocProvider(create: (context) => ProfileClientCubit(ProfileClientRepo())..getClientById()
        ),
        BlocProvider(create: (context) => SearchCubit(),
        ),
        ////////////////////////////   strip
        // BlocProvider(
        //   create: (context) => StripPaymentCubit(CheckoutRepoImpl()),
        // ),

        BlocProvider(
          create: (context) => FavoriteCubit()..loadFavorites(),
        ),
      ],

      child: ScreenUtilInit(
        minTextAdapt: true,
        ensureScreenSize: true,
        splitScreenMode: true,
        designSize: const Size(392, 872),
        child: MaterialApp(
          navigatorObservers: [routeObserver], // 👈 مهم جداً
          debugShowCheckedModeBanner: false,
          title: 'Warcha+ App',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
            fontFamily: "Inter",
          ),
          navigatorKey: navigatorKey,
          // localizationsDelegates: const [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          // supportedLocales: const [
          //   Locale('ar'),
          // ],
          initialRoute: Routes.splash,
          onGenerateRoute: appRouting.generateRout,
        ),
      ),
    );
  }
}
