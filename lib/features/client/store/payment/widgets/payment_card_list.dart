import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:warcha_final_progect/features/client/store/payment/widgets/payment_card_item.dart';

class PaymentCardList    extends StatefulWidget {
  const PaymentCardList  ({super.key, required this.updatePaymentMethod});
  final Function({required int index}) updatePaymentMethod;
  @override
  State<PaymentCardList  > createState() => _PaymentCardListState();
}

class _PaymentCardListState extends State<PaymentCardList  > {
  List<Widget> paymentItem=[
    SvgPicture.asset("assets/images/master_card.svg" ,height: 30, fit: BoxFit.scaleDown,),
   SvgPicture.asset("assets/images/paypal.svg" ,height: 30, fit: BoxFit.scaleDown,),
   Icon(Icons.add , size: 65,color:Colors.blueGrey ,)

  ];
  int activeIndex=0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: ListView.builder(
        itemCount: paymentItem.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeIndex = index;
                        });
                        widget.updatePaymentMethod(index: activeIndex);

                      },
                      child: PaymentCardItem(
                              widget: paymentItem[index],
                                  isActive: activeIndex == index,

                      ),
                    ),
                  );
        },


      ),
    );
  }
}
