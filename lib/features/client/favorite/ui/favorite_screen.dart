import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/features/client/favorite/ui/widgets/list_favorite_body.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/title_appbar.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(children: [
          TitleAppbar(),
          ListFavoriteBody(),
           SizedBox(height: 24.h)]),
      ),
    );
  }
}
