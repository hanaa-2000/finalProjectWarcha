part of 'stor_workshop_cubit.dart';

@immutable
sealed class StorWorkshopState {}

final class StorWorkshopInitial extends StorWorkshopState {}
class GetAccessoriesSuccess extends StorWorkshopState {
final List<AccessoriesModel> list;
GetAccessoriesSuccess({required this.list});
}

class GetAccessoriesLoading extends StorWorkshopState {}

class GetAccessoriesFailure extends StorWorkshopState {
  final String errorMsg;

  GetAccessoriesFailure({required this.errorMsg});
}
class RefreshData extends StorWorkshopState {}


class ProductBookingLoading extends StorWorkshopState {}
class ProductBookingSuccess extends StorWorkshopState {}
class ProductBookingError extends StorWorkshopState {
  final String errorMessage;
  ProductBookingError(this.errorMessage);
}

class ProductBookingState extends StorWorkshopState {
  final String productId;
  final bool isBooking;

  ProductBookingState({required this.isBooking,required this.productId});
}
class ProductCancelBookingSuccess extends StorWorkshopState {}

class ReviewLoading extends StorWorkshopState {}

class ReviewSuccess extends StorWorkshopState {}

class ReviewError extends StorWorkshopState {
  final String message;
  ReviewError(this.message);
}

class ReviewLoaded extends StorWorkshopState {
  final List<ReviewModel> reviews;
  ReviewLoaded(this.reviews);
}
