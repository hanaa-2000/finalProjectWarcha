import 'package:flutter/material.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class CostumeButtonApp  extends StatelessWidget {
  const CostumeButtonApp({super.key, required this.title, this.onPressed, this.color});
 final String title ;
 final void Function()? onPressed;
 final Color ? color;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:onPressed ,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color??ColorApp.mainApp),
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
       child: Text(title , style: AppTextStyle.font16WhiteMedium,),);
  }
}
