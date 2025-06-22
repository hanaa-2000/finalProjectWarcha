import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/model/payment_intent_input.dart';
import 'package:warcha_final_progect/features/client/store/payment/data/repo/checkout_repo.dart';

part 'strip_payment_state.dart';

class StripPaymentCubit extends Cubit<StripPaymentState> {
  StripPaymentCubit(this.checkoutRepo) : super(StripPaymentInitial());

  final CheckoutRepo checkoutRepo;

  Future makePayment(
      {required PaymentIntentInput paymentIntentInputModel}) async {
    emit(StripPaymentLoading());

    var data = await checkoutRepo.makePayment(
        paymentIntentInputModel: paymentIntentInputModel);

    data.fold(
          (l) => emit(StripPaymentFailure(l.toString())),
          (r) => emit(
        StripPaymentSuccess(),
      ),
    );
  }

  @override
  void onChange(Change<StripPaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }

}
