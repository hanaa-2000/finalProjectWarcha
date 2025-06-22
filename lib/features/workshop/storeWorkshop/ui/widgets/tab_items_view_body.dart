import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:warcha_final_progect/core/helper/shared_pref_helper.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_empty_list.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/data/product_model.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/data/store_repo.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/logic/store_cubit.dart';
import 'package:warcha_final_progect/features/workshop/storeWorkshop/ui/widgets/add_item_screen.dart';

class TabItemsViewBody extends StatefulWidget {
  const TabItemsViewBody({super.key});

  @override
  State<TabItemsViewBody> createState() => _TabItemsViewBodyState();
}

class _TabItemsViewBodyState extends State<TabItemsViewBody> {


  late StoreCubit _storeCubit;
  String userName='';
  String userId = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<StoreCubit>(context).fetchProducts(); // استخدم في didChangeDependencies
  }
  @override
  void initState() {
    super.initState();
    _loadData();
    setState(() {

    });
    _storeCubit = StoreCubit(StoreRepo());
    _storeCubit.fetchProducts(); // جلب المنتجات في initState
  }
  _loadData()async{
    userName= await SharedPrefHelper.getString("name");
    userId =await SharedPrefHelper.getString("id");
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          BlocProvider(
            create: (context) =>
            StoreCubit(StoreRepo())
              ..fetchProducts(),
            child: BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {
                if (state is GetProductsSuccess) {
                  //BlocProvider.of<StoreCubit>(context).fetchProducts();

                }
                if (state is ProductLoading) {
                  CustomLoadingWidget();
                }
                if(state is ProductDeleted){
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: "Confirm",
                    text: "Product Deleted Successfully!",
                    confirmBtnText: "OK",
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop(); // إغلاق الحوار
                      // Navigator.of(context).pop(); // إغلاق الحوار
                      BlocProvider.of<StoreCubit>(context).fetchProducts();

                    },
                  );
                  print("Deleted");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Deleted Successfully!')));

                }
                if(state is ProductFailure){

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Deleted error ${state.errorMsg}!')));

                }
              },
              builder: (context, state) {
                if (state is GetProductsLoading || state is ProductLoading) {
                  return CustomLoadingWidget();
                }
                else if (state is GetProductsSuccess) {
                  final products = state.list;
                     if(products.isEmpty){
                       return CustomEmptyList(title: "No Data Now , Enter Your Product ");
                     }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return buildCardItems(context, products[index]);
                    },);
                } else if (state is GetProductsFailure) {
                  return CustomErrorWidget(errorMessage: state.errorMsg);
                }
                return SizedBox.shrink();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => AddItemScreen(),));
            },
              shape: CircleBorder(),
              backgroundColor: Colors.blue,
              child: Icon(Icons.add, color: Colors.white, size: 30.r,),
            ),
          )
        ],
      ),
    );
  }

  buildCardItems(context, ProductModel products) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 4.h,
          vertical: 16.w,
        ),
        margin: EdgeInsetsDirectional.symmetric(
          horizontal: 4.h,
          vertical: 12.w,
        ),
        width: MediaQuery
            .sizeOf(context)
            .width,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: Color(0xffe9ecef)),
          ),
          color: Colors.white,
          shadows: const [
            BoxShadow(
              color: Color.fromARGB(255, 241, 244, 248),
              blurRadius: 3.0, // soften the shadow
              spreadRadius: 3.0, //extend the shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 120.h,
                width: 100.w,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    imageUrl: products.image,
                    // المسار الخاص بالصورة
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(color: Colors.blue,),
                        ),
                    errorWidget: (context, url, error) =>
                        Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Icon(Icons.image, size: 48.r,
                            color: ColorApp.greyColor,),
                        ),
                    // يمكنك إضافة تأثير الانتقال للصور بسرعة
                    fadeInDuration: Duration(milliseconds: 300),
                    fadeOutDuration: Duration(milliseconds: 300),
                  ),
                ),
              ),
              // Container(
              //   height: 120.h,
              //   width: 100.w,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16.r),
              //     image:  DecorationImage(
              //       image: NetworkImage(products.image),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
            ),

            SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products.companyName,
                    style: AppTextStyle.font16BlackW700,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        products.countryManufacture,
                        style: AppTextStyle.fontStyleGrey14400w,
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        height: 16.h,
                        width: 1.w,
                        color: ColorApp.greyColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        products.yearManufacture,
                        style: AppTextStyle.fontStyleGrey14400w,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          //Icon(Icons.price_check,color: Colors.green,),
                          Text(
                            "\$",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.sp
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            height: 16.h,
                            width: 1.w,
                            color: ColorApp.greyColor,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            products.price,
                            style: AppTextStyle.fontStyleGrey14400w,
                          ),
                        ],
                      ),

                      IconButton(
                          onPressed: () {
                            BlocProvider.of<StoreCubit>(context).deleteProduct(products.id);


                          }, icon: Icon(Icons.delete, color: Colors.red,)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // @override
  // void dispose() {
  //   BlocProvider.of<StoreCubit>(context).close();
  //   _storeCubit.close();
  //   super.dispose();
  // }
}
