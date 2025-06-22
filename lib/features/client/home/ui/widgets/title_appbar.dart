import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/helper/spacing.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_shimmer_loading.dart';
import 'package:warcha_final_progect/features/client/home/logic/search/search_cubit.dart';
import 'package:warcha_final_progect/features/client/home/ui/search_screen.dart';
import 'package:warcha_final_progect/features/client/profile/logic/profile_client_cubit.dart';
import 'package:warcha_final_progect/features/client/profile/ui/profile_screen.dart';

class TitleAppbar extends StatefulWidget {
  const TitleAppbar({super.key});

  @override
  State<TitleAppbar> createState() => _TitleAppbarState();
}

class _TitleAppbarState extends State<TitleAppbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _imageSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(3, 3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Row(
                  children: [
                    // ,
                    BlocBuilder<ProfileClientCubit, ProfileClientState>(
                      builder: (context, state) {
                        if (state is ClientLoading) {
                          return CustomShimmerLoadingContainer(
                            width: 24.h,
                            height: 12.w,
                          );
                        } else if (state is ClientLoaded) {
                          final client = state.client;
                          print("object${client.name}");
                          final clientName = SharedPrefHelper.saveDataByKey("nameClient", client.name);
                          final clientPhone = SharedPrefHelper.saveDataByKey("phoneClient",client.phone);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100.r),

                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ProfileScreen(),
                                          ),
                                        );
                                      },
                                      child: SlideTransition(
                                        position: _imageSlideAnimation,
                                        child:ClipOval(
                                          child:
                                          (state.client.image!.isNotEmpty)
                                              ? Image.network(
                                            state. client.image!,
                                            width: 45.r,
                                            height: 45.r,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                                ) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  color: Colors.blue,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.account_circle,
                                                  size: 150.r,
                                                  color: Colors.grey[300],
                                                ),
                                          )
                                              : Image.asset("assets/images/user_image.png" , width:40.w,height:40.w,) ,
                                          // Icon(
                                          //   Icons.account_circle,
                                          //   color: Colors.grey[300],
                                          //   size: 150.r,
                                          // ),

                                        ),

                                        // Image.network(
                                        //   client.image ?? '',
                                        //   width: 40,
                                        //   height: 40,
                                        // ),
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(4),
                                  Text(
                                    "Hi, ${client.name}!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "How Are you Today?",
                                style: TextStyle(
                                  color: ColorApp.greyColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          );
                        } else if (state is ClientError) {
                          return SizedBox(
                            // width: 50.w,
                            //   height: 50.w,
                            //   child: CustomErrorWidget(errorMessage: state.message)
                               );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(12.r),
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                icon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget buildSearch(){
  //   return
  //
  //
  //   }
}
