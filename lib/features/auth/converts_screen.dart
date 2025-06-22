import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/extension.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/auth/logic/auth_cubit.dart';

class ConvertsScreen extends StatelessWidget {
  const ConvertsScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200.w,
                    height: 250.h,
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () async{
                      context.read<AuthCubit>().setUserType("client");
                     context.pushReplacementNamed(Routes.login);
                                   },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          ColorApp.mainApp),
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
                        "Client", style: AppTextStyle.font16WhiteMedium),
                  ),
                  SizedBox(height: 30.h),
                  TextButton(
                    onPressed: ()async {
                      context.read<AuthCubit>().setUserType("workshop");


                      context.pushReplacementNamed(Routes.login);
                                   },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 52),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: ColorApp.mainApp, width: 2),
                        ),
                      ),
                    ),
                    child: Text(
                      "Workshop",
                      style: AppTextStyle.font16WhiteMedium.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
