import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_empty_list.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/client/home/logic/workshops_cubit.dart';

class MechanicScreen extends StatefulWidget {
  const MechanicScreen({super.key, required this.workshopId});
final String workshopId;
  @override
  State<MechanicScreen> createState() => _MechanicScreenState();
}

class _MechanicScreenState extends State<MechanicScreen> {
  @override
  void initState() {
    BlocProvider.of<WorkshopsCubit>(context).getPeople(widget.workshopId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BlocBuilder<WorkshopsCubit, WorkshopsState>(
          builder: (context, state) {
            if(state is MechanicalLoading){
              return CustomLoadingWidget();
            }
            else if(state is MechanicalError){
              return CustomErrorWidget(errorMessage: state.message);
            } else if(state is MechanicalLoaded){
              final list = state.mechanical;
              if(list.isEmpty){
                return CustomEmptyList(title: "Not Find Mechanical now ");
              }
               return ListView.builder(
                 itemCount: list.length,
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return Container(
                     padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
                     margin: EdgeInsets.symmetric(horizontal: 32.w,vertical:12.h),
                     height: 60.h,
                     decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r),
                     ),
                       color: ColorApp.greyLight,

                     ),
                     child: Center(child: Text(list[index] , style: AppTextStyle.font16BlackW700,)),
                   ) ;
                 },

               );
            }
            return SizedBox.shrink();

          },
        ),
      ],
    );
  }
}
