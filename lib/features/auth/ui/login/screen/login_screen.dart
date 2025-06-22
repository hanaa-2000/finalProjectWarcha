import 'package:flutter/material.dart';
import 'package:warcha_final_progect/features/auth/ui/login/widgets/login_body.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: LoginBody(),
      ),
    );
  }
}
