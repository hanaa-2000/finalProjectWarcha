import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';

class AppTextFormField extends StatelessWidget {
  final Widget? suffixIcon;
  final TextStyle? labelStyle;
  final String labelText;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? enabledBorder;
  final Color? backgroundColor;
  final InputBorder? focusedBorder;
  final bool? obscureText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String?) validator;
  final int? maxLines;
  final String? counterText;
  final bool? readOnly;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const AppTextFormField({
    super.key,
    this.suffixIcon,
    this.labelStyle,
    required this.labelText,
    this.contentPadding,
    this.backgroundColor,
    this.enabledBorder,
    this.focusedBorder,
    this.obscureText,
    this.controller,
    this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.counterText,
    this.onChanged,
    this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly ?? false,
      maxLines: maxLines,
      controller: controller,
      validator: (value) {
        return validator(value);
      },
      decoration: InputDecoration(
        counterText: counterText,
        label: Text(labelText),
        labelStyle: labelStyle ?? AppTextStyle.fontLightGrey14500w,
        contentPadding: contentPadding ??
            EdgeInsetsDirectional.symmetric(vertical: 20.h, horizontal: 18.w),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: enabledBorder ??
             OutlineInputBorder(
               gapPadding: 10.r,
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                borderSide: BorderSide(
                  width: 1.w,

                  color:ColorApp.greyLight,
                )),
        focusedBorder: focusedBorder ??
             OutlineInputBorder(
                 gapPadding: 10.r,
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                borderSide: BorderSide(
                  color: ColorApp.greyLight,
                  width: 1.w,
                )),
        fillColor: backgroundColor ?? ColorApp.fieldGrey,
        filled: true,
      ),
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: ColorApp.mainApp,
    );
  }
}
