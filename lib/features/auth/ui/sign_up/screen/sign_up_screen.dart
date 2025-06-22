import 'package:flutter/material.dart';
import 'package:warcha_final_progect/features/auth/ui/sign_up/widgets/sign_up_body.dart';

class SignUpScreen  extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body: SignUpBody(),
    );
  }
}
