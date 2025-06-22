import 'package:flutter/material.dart';
import 'package:warcha_final_progect/features/client/store/payment/widgets/custom_button_bloc_consumer.dart';
import 'package:warcha_final_progect/features/client/store/payment/widgets/payment_card_list.dart';
import 'package:warcha_final_progect/features/client/store/payment/widgets/payment_screen.dart';

class PaymentBottomSheet  extends StatefulWidget {
  const PaymentBottomSheet({super.key, required this.price});
  final int  price;

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  bool isPaypal = false;

  updatePaymentMethod({required int index}) {
    if (index == 0) {
      setState(() {
        isPaypal = false;

      });

    } else if(index == 1) {
     setState(() {
       isPaypal = true;
     });

    } else{
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentScreen(),));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(padding: EdgeInsets.all(16),
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25,),
            PaymentCardList(updatePaymentMethod: updatePaymentMethod,),
            SizedBox(height: 32,),
            CustomButtonBlocConsumer(price: widget.price,isPaypal: isPaypal,),


          ],
        )
    )
    ;
  }
}
