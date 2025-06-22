//
// import 'package:dartz/dartz.dart';
// import 'package:warcha_final_progect/features/client/store/payment/data/error/failure.dart';
// import 'package:warcha_final_progect/features/client/store/payment/data/model/payment_intent_input.dart';
// import 'package:warcha_final_progect/features/client/store/payment/data/repo/checkout_repo.dart';
// import 'package:warcha_final_progect/features/client/store/payment/data/services/strip_services.dart';
//
// class CheckoutRepoImpl extends CheckoutRepo {
//   final StripService stripeService = StripService();
//   @override
//   Future<Either<Failure, void>> makePayment(
//       {required PaymentIntentInput paymentIntentInputModel}) async {
//     try {
//       await stripeService.makePayment(
//           paymentIntentInput: paymentIntentInputModel);
//
//       return right(null);
//     } on StripeException catch (e) {
//       return left(ServerFailure(
//           errMessage: e.error.message ?? 'Oops there was an error'));
//     } catch (e) {
//       return left(ServerFailure(errMessage: e.toString()));
//     }
//   }
// }
//
//
//
//
//
