import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/helper/extension.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/client/profile/ui/widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ProfileScreenBody(),


      //     BlocConsumer<ProfileClientCubit, ProfileClientState>(
      //   listener: (context, state) {
      //
      //   },
      //   builder: (context, state) {
      //     if(state is ClientLoading ){
      //       return CustomLoadingWidget();
      //     }else if(state is ClientLoaded){
      //       final client = state.client;
      //       print("object${client.name}");
      //       print("object${client.email}");
      //       print("object${client.phone}");
      //       return Column(
      //         children: [
      //
      //           IconButton(onPressed: () async {
      //             await FirebaseAuth.instance.signOut();
      //             context.pushReplacementNamed(Routes.splash);
      //           }, icon: Icon(Icons.lock, color: Colors.red,)),
      //           Center(
      //             child: Text("client   homeeeeeeeee"),
      //           ),
      //
      //         ],
      //       );
      //     }else if(state is ClientError){
      //       return CustomErrorWidget(errorMessage: state.message);
      //     }
      //     return SizedBox.shrink();
      //
      //   },
      // ),

      ),
      bottomNavigationBar:  InkWell(
        onTap: () async{
          try {
            await FirebaseAuth.instance.signOut();
            print("Signed out successfully!");
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, Routes.splash, (route) => false,);

             // context.pushReplacementNamed(Routes.);
            }
          } catch (e) {
            print("Error signing out: $e");
          }
        },
        child: Container(
          width: 58,
          height: 60,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          margin:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: BorderSide(color: ColorApp.greyLight),
            ),
            color: Colors.red,
          ),
          child: Center(
            child: Text(
              "Log Out",
              style: AppTextStyle.font16WhiteMedium,
            ),
          ),
        ),
      ),
    );
  }
}
