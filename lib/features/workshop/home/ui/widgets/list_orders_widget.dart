import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/core/widgets/custom_empty_list.dart';
import 'package:warcha_final_progect/core/widgets/custom_error_widget.dart';
import 'package:warcha_final_progect/core/widgets/custom_loading_widget.dart';
import 'package:warcha_final_progect/features/workshop/home/logic/workshop_home_cubit.dart';
import 'package:warcha_final_progect/features/workshop/home/ui/widgets/card_orders_widget.dart';

class ListOrdersWidget extends StatefulWidget {
  const ListOrdersWidget({super.key});

  @override
  State<ListOrdersWidget> createState() => _ListOrdersWidgetState();
}

class _ListOrdersWidgetState extends State<ListOrdersWidget> {
  @override
  void initState() {
    BlocProvider.of<WorkshopHomeCubit>(context).fetchUserOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkshopHomeCubit, WorkshopHomeState>(
      builder: (context, state) {
      //  print("OrderDetailsScreen rebuilt at ${DateTime.now()}");
        if (state is OrdersLoading) {
          return const CustomLoadingWidget();
        }
        else if (state is OrdersError) {
          return CustomErrorWidget(errorMessage: "Error: ${state.errMsg}");
        }
       else if (state is NoOrderFound) {
          return Expanded(
              child: CustomEmptyList(title:  "No active bookings found")) ;

        }
       else if (state is OrderLoaded) {
          final order = state.order;
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:order.length ,
              itemBuilder: (context, index) {
                return CardOrdersWidget(order: order[index],);
              },),
          );
        }
     return SizedBox.shrink();
      },
    );
  }
}
