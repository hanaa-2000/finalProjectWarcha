//
//
// import 'package:dio/dio.dart';
// import 'package:warcha_final_progect/core/model/ephemeral_key_model/ephemeral_key_model.dart';
// import 'package:warcha_final_progect/features/client/store/payment/data/model/payment_intent.dart';
// import 'package:warcha_final_progect/features/client/store/payment/data/model/payment_intent_input.dart';
// import 'package:warcha_final_progect/features/client/store/payment/data/services/api_keys.dart';
// import 'package:warcha_final_progect/features/client/store/payment/data/services/api_services.dart';
//
// class StripService {
//   final ApiService apiServices = ApiService();
//
//   Future<PaymentIntentModel> createPaymentIntent(
//       PaymentIntentInput paymentIntentInput) async {
//     var respond = await apiServices.post(
//       contentType: Headers.formUrlEncodedContentType,
//         body: paymentIntentInput.toJson(),
//         url: "https://api.stripe.com/v1/payment_intents",
//         token: ApiKeys.secretKey);
//
//     var paymentIntentModel = PaymentIntentModel.fromJson(respond.data);
//
//     return paymentIntentModel;
//
//   }
//   Future<PaymentIntentModel> createPaymentCustomer(
//       PaymentIntentInput paymentIntentInput) async {
//     var respond = await apiServices.post(
//         contentType: Headers.formUrlEncodedContentType,
//         body: paymentIntentInput.toJson(),
//         url: "https://api.stripe.com/v1/payment_intents",
//         token: ApiKeys.secretKey);
//
//     var paymentIntentModel = PaymentIntentModel.fromJson(respond.data);
//
//     return paymentIntentModel;
//
//   }
//
//
//   Future initPaymentSheet({required String paymentIntentClientSecret , })async{
//
//    await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentClientSecret,
//           // customerEphemeralKeySecret: ephermeralKey,
//           // customerId: "pm_1Qf4jZBGqlWulEj2GEodn8kt",
//           merchantDisplayName: 'Hanaa',
//         ));
//
//
//   }
//
//   Future displayPaymentSheet()async{
//
//   await  Stripe.instance.presentPaymentSheet();
//
//   }
//
// Future makePayment({required PaymentIntentInput paymentIntentInput})async{
//  var paymentIntentModel = await createPaymentIntent(paymentIntentInput);
//  await initPaymentSheet(paymentIntentClientSecret: paymentIntentModel.clientSecret);
//
//  await displayPaymentSheet();
// }
//
//
//
//   Future<EphemeralKeyModel> createEphemeralKey(
//       {required String customerId}) async {
//     var response = await apiServices.post(
//         body: {'customer': customerId},
//         contentType: Headers.formUrlEncodedContentType,
//         url: 'https://api.stripe.com/v1/ephemeral_keys',
//         token: ApiKeys.secretKey,
//         headers: {
//           'Authorization': "Bearer ${ApiKeys.secretKey}",
//           'Stripe-Version': '2024-12-18',
//         });
//
//     var ephermeralKey = EphemeralKeyModel.fromJson(response.data);
//
//     return ephermeralKey;
//   }
// }
