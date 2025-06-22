import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/title_appbar.dart';
import 'package:warcha_final_progect/features/client/store/logic/stor_workshop_cubit.dart';
import 'package:warcha_final_progect/features/client/store/ui/widgets/card_accessory_widget.dart';

class StoreClientBody  extends StatefulWidget {
  const StoreClientBody({super.key});

  @override
  State<StoreClientBody> createState() => _StoreClientBodyState();
}

class _StoreClientBodyState extends State<StoreClientBody> {
  @override
  void didChangeDependencies() {
    BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();
    super.didChangeDependencies();
  }
  @override
  void initState() {
    BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();
    super.initState();
  }
  void didPopNext() {
    // 📌 يتم استدعاؤها لما ترجع للشاشة دي
    BlocProvider.of<StorWorkshopCubit>(context).fetchProducts();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w , vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAppbar(),
          SizedBox(height: 24.h,),
          SizedBox(height: 24.h,),
          Text("Accessories" , style: AppTextStyle.font18BlackW600,),
          Expanded(child: CardAccessoryWidget()),
        ],
      ),
    ));
  }
}
