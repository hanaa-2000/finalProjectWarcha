import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warcha_final_progect/core/theme/color_app.dart';
import 'package:warcha_final_progect/core/theme/style_app.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/manager/strip_payment_cubit.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/model/payment_intent_input.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/model/paypal_model/amount_model/amount_model.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/model/paypal_model/amount_model/details.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/model/paypal_model/item_list_model/item.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/model/paypal_model/item_list_model/item_list_model.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/services/api_keys.dart';
import 'package:warcha_final_progect/features/client/store/payment/widgets/payment_screen.dart';


class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({super.key, required this.price, required this.isPaypal});

  final int price;
 final bool isPaypal;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StripPaymentCubit, StripPaymentState>(
      listener: (context, state) {
        if (state is StripPaymentSuccess) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentScreen(),
          ));
          // QuickAlert.show(
          //   context: context,
          //   type: QuickAlertType.success,
          //   title: "Congratulation",
          //   text: "You are paid the accessories",
          //   confirmBtnText: "OK",
          // );

        }
        if (state is StripPaymentFailure) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(content: Text(state.errMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print(state.errMessage);
        }
      },
      builder: (context, state) {
        return CustomButton(
          isLoading: state is StripPaymentLoading ? true : false,
          text: "Continue",
          onPressed: () {
            // PaymentIntentInput paymentIntentInput =
            //     PaymentIntentInput(amount: "$price", currency: "USD",);
            // BlocProvider.of<StripPaymentCubit>(context)
            //     .makePayment(paymentIntentInputModel: paymentIntentInput);
            if (isPaypal) {
             var transctionsData = getTransctionsData();
             //exceutePaypalPayment(context, transctionsData);
            } else {
              excuteStripePayment(context);
            }

           // exceutePaypalPayment(context,);

          },
        );
      },
    );
  }
  void excuteStripePayment(BuildContext context) {
    PaymentIntentInput paymentIntentInputModel = PaymentIntentInput(
      amount: "$price",
      currency: 'USD',
     );
    BlocProvider.of<StripPaymentCubit>(context)
        .makePayment(paymentIntentInputModel: paymentIntentInputModel);
  }

  // void exceutePaypalPayment(BuildContext context,
  //     ({AmountModel amount, ItemListModel itemList}) transctionsData) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (BuildContext context) => PaypalCheckoutView(
  //       sandboxMode: true,
  //       clientId: ApiKeys.paypalClientId,
  //       secretKey: ApiKeys.paypalSecretKey,
  //       transactions: [
  //         {
  //           "amount": transctionsData.amount.toJson(),
  //           "description": "The payment transaction description.",
  //           "item_list": transctionsData.itemList.toJson(),
  //         }
  //       ],
  //       note: "Contact us for any questions on your order.",
  //       onSuccess: (Map params) async {
  //         log("onSuccess: $params");
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) {
  //             return const PaymentScreen();
  //           }),
  //               (route) {
  //             if (route.settings.name == '/') {
  //               return true;
  //             } else {
  //               return false;
  //             }
  //           },
  //         );
  //       },
  //       onError: (error) {
  //         SnackBar snackBar = SnackBar(content: Text(error.toString()));
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) {
  //             return const PaymentScreen();
  //           }),
  //               (route) {
  //             return false;
  //           },
  //         );
  //       },
  //       onCancel: () {
  //         print('cancelled:');
  //         Navigator.pop(context);
  //       },
  //     ),
  //   ));
  // }
  // void exceutePaypalPayment(BuildContext context) {
  //   var transactionData=getTransctionsData();
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (BuildContext context) => PaypalCheckoutView(
  //       sandboxMode: true,
  //       clientId: ApiKeys.paypalClientId,
  //       secretKey: ApiKeys.secretKey,
  //       transactions: [
  //         {
  //           "amount": transactionData.amount,
  //           "description": "The payment transaction description.",
  //           "item_list": transactionData.itemList,
  //         }
  //       ],
  //       note: "Contact us for any questions on your order.",
  //       onSuccess: (Map params) async {
  //         log("onSuccess: $params");
  //         Navigator.pop(context);
  //       },
  //       onError: (error) {
  //         log("onError: $error");
  //         Navigator.pop(context);
  //       },
  //       onCancel: () {
  //         print('cancelled:');
  //         Navigator.pop(context);
  //       },
  //     ),
  //   ));
  // }


  ({AmountModel amount, ItemListModel itemList}) getTransctionsData() {
    var amount = AmountModel(
        total: "100",
        currency: 'USD',
        details: Details(shipping: "0", shippingDiscount: 0, subtotal: '100'));

    List<OrderItemModel> orders = [
      OrderItemModel(
        currency: 'USD',
        name: 'Apple',
        price: "4",
        quantity: 10,
      ),
      OrderItemModel(
        currency: 'USD',
        name: 'Apple',
        price: "5",
        quantity: 12,
      ),
    ];

    var itemList = ItemListModel(orders: orders);

    return (amount: amount, itemList: itemList);
  }


}
class CustomButton  extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onPressed, this.isLoading=false});
  final String text;
  final void Function() onPressed;
  final bool isLoading ;

  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 160,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.mainApp,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(64.0),
              ),
            ),
            onPressed: onPressed,
            child: isLoading?Center(child: CircularProgressIndicator()) : Text(
              text,
              style:AppTextStyle.font16WhiteMedium
            ),
          ),
        ),
      ],
    );
  }
}