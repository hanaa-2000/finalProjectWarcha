import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:warcha_final_progect/core/helper/spacing.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/app_text_field.dart';
import 'package:warcha_final_progect/core/widgets/custom_empty_list.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/client/home/data/reviwes_model.dart';
import 'package:warcha_final_progect/features/client/home/logic/workshops_cubit.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.workshopId, });
final String workshopId ;
// final String nameClient;
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    BlocProvider.of<WorkshopsCubit>(context).getReviews(widget.workshopId);
    super.initState();
  }
  double selectedRating = 3.0;

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("اختر التقييم"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: selectedRating,
                minRating: 1,
                maxRating: 5,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.r,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    selectedRating = rating;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                "التقييم: ${selectedRating.toStringAsFixed(1)}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _submitReview();
              },
              child: const Text("تأكيد"),
            ),
          ],
        );
      },
    );
  }

  void _submitReview() {
    final comment = reviewController.text.trim();
    if (comment.isEmpty) return;

    context.read<WorkshopsCubit>().addReview(
      productId: widget.workshopId,
      userId: FirebaseAuth.instance.currentUser!.uid,
      rating: selectedRating,
      comment: comment,
    );

    reviewController.clear();
    selectedRating = 3.0;
  }
  TextEditingController reviewController = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey();
  DateTime parseDateTime(String timestamp) {
    // نحول النص إلى DateTime
    DateFormat format = DateFormat("MMMM d, yyyy 'at' hh:mm:ss a 'UTC'x");
    return format.parse(timestamp);
  }

  String formatDateOnly(DateTime date) {
    // نرجع التاريخ فقط
    return DateFormat('MMMM d, yyyy').format(date);
  }
    @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<WorkshopsCubit, WorkshopsState>(
                 builder: (context, state) {
                   if(state is ReviewLoading){
                     return CustomLoadingWidget();
                     //
                   }
                   else if(state is ReviewError){

                     return CustomErrorWidget(errorMessage: state.message);
                   }
                   else if(state is ReviewLoaded){
                     final list = state.reviews;
                     if(list.isEmpty){
                       return Center(
                         child: SingleChildScrollView(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               SvgPicture.asset(
                                 "assets/images/no_data.svg",
                                 width: MediaQuery.sizeOf(context).width / 2,
                               ),


                               verticalSpace(32),
                               Text(
                                 "No Reviews No",
                                 style: AppTextStyle.font18BlackW600,
                               ),
                               //   const Spacer()
                             ],
                           ),
                         ),
                       );
                     }
                     return ListView.builder(
                       shrinkWrap: true,
                       itemCount: list.length,
                       itemBuilder: (context, index) {
                       return buildCard(list[index]);
                     },);
                   }
                   return SizedBox.shrink();

           },
         ),
        verticalSpace(60),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formState,
            child: Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    labelText: "make Review",
                    validator:(value) {
                      if(value==null|| value.isEmpty){
                        return "Please enter your review";
                      }
                      return null;
                    } ,
                    controller: reviewController,
                  ),
                ),
                IconButton(onPressed:  () {
                  if(_formState.currentState!.validate()){
                    print("object");
                    _showRatingDialog();
                  }

               }, icon: Icon(Icons.star,color: Colors.yellow,size: 30.r,)
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  buildCard(ReviewModel list) {
    String date = DateFormat('yyyy-MM-dd').format(list.timestamp);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: Image.asset(
                      "assets/images/Image2.png",
                      width: 50.w,
                      height: 50.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list.nameClient??'jjjjjjjj', style: AppTextStyle.font16BlackW700),
                      RatingBarIndicator(
                        rating:list.rating,
                        itemSize: 25.r,
                        itemBuilder:
                            (context, index) =>
                            Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                ],
              ),
              Text(date,style: AppTextStyle.fontStyleGrey12400w),
            ],
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:6.w, vertical: 4.h),
            child: Text(
            //  "As someone who lives in a remote area with limited access to car service centers, this specialized auto service app has been a game changer for me. I can easily book maintenance or repair appointments with nearby centers and get the service I need without having to travel long distances.",
             list.comment!,
              style: AppTextStyle.fontStyleGrey14400w.copyWith(
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
