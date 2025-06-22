import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/core/widgets/drawer_body.dart';
import 'package:warcha_final_progect/features/workshop/home/data/workshop_home_repo.dart';
import 'package:warcha_final_progect/features/workshop/home/logic/workshop_home_cubit.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/widgets/title_workshop_appbar.dart';
import 'package:warcha_final_progect/features/workshop/profile/ui/widgets/profile_body.dart';

class ProfileWorkshopScreen extends StatefulWidget {
  const ProfileWorkshopScreen({super.key});

  @override
  State<ProfileWorkshopScreen> createState() => _ProfileWorkshopScreenState();
}

class _ProfileWorkshopScreenState extends State<ProfileWorkshopScreen> {

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

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leadingWidth: 0.w,
        actions: [SizedBox.shrink()],
        leading: SizedBox.shrink(),
        title: TitleWorkshopAppbar(),
      ),
      body: ProfileBody(),
    );
  }


}
