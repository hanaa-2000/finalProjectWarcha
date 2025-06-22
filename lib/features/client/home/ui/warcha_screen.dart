import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/client/favorite/logic/favorite_cubit.dart';
import 'package:warcha_final_progect/features/client/home/data/workshop_model.dart';
import 'package:warcha_final_progect/features/client/home/logic/workshops_cubit.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/button_bottom_nav.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/chat_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/location_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/mechanic_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/reviews_screen.dart';

class WarchaScreen extends StatefulWidget {
  const WarchaScreen({super.key, required this.list});

  final WorkshopModel list;

  @override
  State<WarchaScreen> createState() => _WarchaScreenState();
}

class _WarchaScreenState extends State<WarchaScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  // String location ='';
  final List<String> _tabs = ["Location","Mechanics", "Reviews"];
  late final List<Widget> _pages;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   _pages = [
  //     LocationScreen(
  //       location: widget.list.location!,
  //       langtiud: widget.list.longitude!,
  //       latituid: widget.list.latitude!,
  //     ),
  //     ReviewsScreen(),
  //   ];
  // }
  //

  bool _isInitialized = false;

  // @override
  //   void initState() {
  //   BlocProvider.of<WorkshopsCubit>(context).fetchWorkshops();
  //   print("object${widget.list.longitude}");
  //     super.initState();
  //   }
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    print("🚀 widget.list = ${widget.list.id}");
    print("🚀 widget.list = ${widget.list.name}");
    print("🚀 widget.list = ${widget.list.isBooked}");
    print("📍 location = ${widget.list.location}");
    print("🧭 lat = ${widget.list.latitude}, long = ${widget.list.longitude}");
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _showSnackBar(BuildContext context, bool added) {
    final message = added ? "تمت الإضافة إلى المفضلة ✅" : "تمت الإزالة من المفضلة ❌";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: added ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _pages = [
        LocationScreen(
          location: widget.list.location ?? '',
          langtiud: widget.list.longitude ?? "",
          latituid: widget.list.latitude ?? "",
        ),
        MechanicScreen(workshopId:widget.list.id ,),
        ReviewsScreen(workshopId: widget.list.id),
      ];
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final  _pages=[
    //     LocationScreen(location:widget.list.location!,langtiud: widget.list.longitude!,latituid:widget.list.latitude! ,),
    //     ReviewsScreen(),
    //   ];
    return Scaffold(
      bottomNavigationBar: ButtonBottomNav(
        workshopId: widget.list.id,
        isBooked: widget.list.isBooked ?? false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Color(0xffF5F5F5),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
                  ),
                ),
                Text(
                  widget.list.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (context, state) {
                    final cubit = context.read<FavoriteCubit>();
                    final isFav = cubit.isFavorite(widget.list.id);
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Color(0xffF5F5F5),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _controller.forward().then((_) => _controller.reverse());
                          cubit.toggleFavorite(widget.list);
                          _showSnackBar(context, !isFav);
                        },
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 4.h,
                        vertical: 16.w,
                      ),
                      margin: EdgeInsetsDirectional.symmetric(
                        horizontal: 4.h,
                        vertical: 12.w,
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 120.h,
                              width: 100.w,

                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(16.r),
                              //   image: list.image != null && list.image!.isNotEmpty
                              //       ? DecorationImage(
                              //     image: CachedNetworkImageProvider(list.image!),
                              //     fit: BoxFit.cover,
                              //   )
                              //       : const DecorationImage(
                              //     image: AssetImage('assets/images/placeholder.png'),
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: widget.list.image ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder:
                                      (context, url) => Container(
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Container(
                                        color: Colors.grey[200],
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.image,
                                          size: 48.r,
                                          color: ColorApp.greyColor,
                                        ),
                                      ),
                                  // يمكنك إضافة تأثير الانتقال للصور بسرعة
                                  fadeInDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  // ← هنا الانتقال
                                  fadeOutDuration: Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 16.w),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.list.name,
                                      style: AppTextStyle.font16BlackW700,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final types.User workshopUser =
                                            types.User(
                                              id: widget.list.id,
                                              // نفس الـ uid الخاص بالورشة
                                              firstName: widget.list.name,
                                            );
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ChatScreen(
                                                  otherUser: workshopUser,
                                                ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.message_rounded,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                GestureDetector(
                                  onTap: () async {
                                    if (widget.list.phone != null) {
                                      final String phone = widget.list.phone;
                                      final Uri callUrl = Uri.parse(
                                        "tel:$phone",
                                      );

                                      if (await canLaunchUrl(callUrl)) {
                                        await launchUrl(callUrl);
                                      } else {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          title: "fail",
                                          text:
                                              "Call could not be started, make sure your phone supports calling",
                                          confirmBtnText: "OK",
                                        );
                                      }
                                    } else {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.warning,
                                        title: "No phone number",
                                        text:
                                            "It appears that this customer does not have a registered phone number.",
                                        confirmBtnText: "OK",
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.local_phone_outlined,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 6.w),
                                      Container(
                                        height: 25.h,
                                        width: 1.w,
                                        color: ColorApp.greyColor,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        widget.list.phone,
                                        style: AppTextStyle.fontStyleGrey14400w,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                RatingBarIndicator(
                                  rating: 2.75,
                                  itemSize: 25.r,
                                  itemBuilder:
                                      (context, index) =>
                                          Icon(Icons.star, color: Colors.amber),
                                  itemCount: 5,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // التابات كأزرار بسيطة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _tabs.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _tabs[index],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color:
                                        _selectedIndex == index
                                            ? Colors.blue
                                            : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // مسافة بين النص والخط
                                Container(
                                  width: 80.w, // تحديد عرض الخط
                                  height: 2.h, // سماكة الخط
                                  decoration: BoxDecoration(
                                    color:
                                        _selectedIndex == index
                                            ? Colors.blue
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(
                                      2.r,
                                    ), // أطراف ناعمة
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    _pages[_selectedIndex], // عرض الصفحة المختارة
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
