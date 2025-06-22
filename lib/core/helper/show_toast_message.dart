import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

showToastMessage({BuildContext ?context ,required String message }){
    showToast(message,
        context: context,
        animation: StyledToastAnimation.slideFromBottomFade,
        reverseAnimation: StyledToastAnimation.slideToBottomFade,
        startOffset: Offset(0.0, 3.0),
        reverseEndOffset: Offset(0.0, 3.0),
        position: StyledToastPosition(
            align: Alignment.bottomCenter, offset: 0.0),
        duration: Duration(seconds: 4),
        //Animation duration   animDuration * 2 <= duration
        animDuration: Duration(milliseconds: 400),
        curve: Curves.linearToEaseOut,
        reverseCurve: Curves.fastOutSlowIn);


  }