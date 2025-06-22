import 'package:flutter/material.dart';

class PaymentCardItem  extends StatelessWidget {
  const PaymentCardItem({super.key, required this.isActive, required this.widget});
  final bool isActive;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 120,
      height: 62,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: isActive ? const Color(0xFF34A853) : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
      shadows: [
        BoxShadow(
          color: isActive ? const Color(0xFF34A853) : Colors.white,
          blurRadius: 4,
          offset: const Offset(0, 0),
          spreadRadius: 0,
        )
      ]
      ),
      child: Container(
        decoration: BoxDecoration(
         color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ) ,
       child:Center(
         child:widget ,
       ) ,


      ),
    );
  }
}
