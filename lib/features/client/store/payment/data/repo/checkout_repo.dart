

import 'package:dartz/dartz.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/error/failure.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/model/payment_intent_input.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInput paymentIntentInputModel});
}
