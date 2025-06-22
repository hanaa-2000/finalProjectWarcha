import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/features/auth/converts_screen.dart';
import 'package:warcha_final_progect/features/auth/data/repo.dart';
import 'package:warcha_final_progect/features/auth/logic/auth_cubit.dart';
import 'package:warcha_final_progect/features/auth/ui/login/screen/login_screen.dart';
import 'package:warcha_final_progect/features/auth/ui/sign_up/screen/sign_up_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/home_client_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/main_home_screen.dart';
import 'package:warcha_final_progect/features/onbording/onbording_screen.dart';
import 'package:warcha_final_progect/features/splash/splash_screen.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/home_workshop_screen.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/main_workshop_screen.dart';

class AppRouting {
  Route? generateRout(RouteSettings setting) {
    final arguments = setting.arguments;
    switch (setting.name) {
      //------------------  splash ------------//
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      //------------------  onboarding ------------//

      case Routes.onbording:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());
      //------------------  LoginScreen ------------//

      case Routes.login:
        return MaterialPageRoute(
          builder:
              (context) => LoginScreen(),
        );
      //------------------  SignUp screen ------------//

      case Routes.signUp:
        return MaterialPageRoute(
          builder:
              (context) => SignUpScreen(),
        );
      ///////////   home client ///////////////////
      case Routes.homeClient:
        return MaterialPageRoute(builder: (context) => MainHomeClientScreen());
      ///////////   home workshop  ///////////////////
      case Routes.homeWorkshop:
        return MaterialPageRoute(builder: (context) => MainWorkshopScreen());

      default:
        return null;
    }
  }
}
