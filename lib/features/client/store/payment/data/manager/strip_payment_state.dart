part of 'strip_payment_cubit.dart';

@immutable
sealed class StripPaymentState {}

final class StripPaymentInitial extends StripPaymentState {}
final class StripPaymentLoading extends StripPaymentState {}
final class StripPaymentSuccess extends StripPaymentState {}
final class StripPaymentFailure extends StripPaymentState {

  final String errMessage;

  StripPaymentFailure(this.errMessage);
}
