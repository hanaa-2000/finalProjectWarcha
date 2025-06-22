part of 'store_cubit.dart';

@immutable
sealed class StoreState {}

final class StoreInitial extends StoreState {}
final class ProductLoading extends StoreState {}
final class ProductSuccess extends StoreState {

}
final class ProductFailure extends StoreState {

  final String errorMsg;

  ProductFailure({required this.errorMsg});
}
class ProductDeleted extends StoreState {}

class GetProductsSuccess extends StoreState {
  final List<ProductModel> list;
  GetProductsSuccess({required this.list});
}

class GetProductsLoading extends StoreState {}

class GetProductsFailure extends StoreState {
  final String errorMsg;

  GetProductsFailure({required this.errorMsg});
}

class ProductBookingLoading extends StoreState {}
class ProductBookingSuccess extends StoreState {
  final List<ProductModel> bookings;

  ProductBookingSuccess(this.bookings);
}

class ProductBookingError extends StoreState {
  final String errorMessage;
  ProductBookingError(this.errorMessage);
}
