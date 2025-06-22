import 'package:flutter/material.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/auth/converts_screen.dart';
import 'package:warcha_final_progect/features/splash/auth_check_screen.dart';

class GetStartedButton  extends StatelessWidget {
  const GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthCheckScreen(),));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorApp.mainApp),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(
          const Size(double.infinity, 52),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      child: Text(
        'Get Started',
        style: AppTextStyle.font16WhiteMedium,
      ),
    );
  }
}
