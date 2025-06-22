part of 'workshops_cubit.dart';

@immutable
sealed class WorkshopsState {}

final class WorkshopsInitial extends WorkshopsState {}

final class GetWorkshopsLoading extends WorkshopsState {}

final class GetWorkshopsSuccess extends WorkshopsState {
  final List<WorkshopModel> list;
  GetWorkshopsSuccess({required this.list});
}

final class GetWorkshopsError extends WorkshopsState {

  final String errMsg;
  GetWorkshopsError({required this.errMsg});

}

final class GetAllWorkshopsLoading extends WorkshopsState {}

final class GetAllWorkshopsSuccess extends WorkshopsState {
  final List<WorkshopModel> list;
  GetAllWorkshopsSuccess({required this.list});
}

final class GetAllWorkshopsError extends WorkshopsState {

  final String errMsg;
  GetAllWorkshopsError({required this.errMsg});

}

final class WorkshopsRefresh extends WorkshopsState {}

final class BookingLoading extends WorkshopsState {}

final class  BookingSuccess extends WorkshopsState {
  final String workshopId;
  final bool isBooked;
  BookingSuccess(this.workshopId, { required this.isBooked });

}

final class  BookingError extends WorkshopsState {

  final String errMsg;
  BookingError({required this.errMsg});

}
// أضف هذا داخل WorkshopsCubit
class BookingStatusChecked extends WorkshopsState {
  final bool isBooked;
  BookingStatusChecked(this.isBooked);
}
// class BookingSuccess extends WorkshopsState {
//   final String workshopId;
//   final bool isBooked;
//   BookingSuccess(this.workshopId, {required this.isBooked});
// }

class BookingCanceled extends WorkshopsState {
  final String workshopId;
  BookingCanceled(this.workshopId);
}


class ReviewLoading extends WorkshopsState {}

class ReviewSuccess extends WorkshopsState {}

class ReviewError extends WorkshopsState {
  final String message;
   ReviewError(this.message);
}

class ReviewLoaded extends WorkshopsState {
  final List<ReviewModel> reviews;
   ReviewLoaded(this.reviews);
}


class WorkshopBookingLoading extends WorkshopsState {}
class WorkshopBookingSuccess extends WorkshopsState {}
class WorkshopBookingError extends WorkshopsState {
  final String errorMessage;
  WorkshopBookingError(this.errorMessage);
}

class WorkshopCancelBookingSuccess extends WorkshopsState {}

class MechanicalLoading extends WorkshopsState {}

class MechanicalAdded extends WorkshopsState {}

class MechanicalError extends WorkshopsState {
  final String message;

  MechanicalError(this.message);
}

class MechanicalLoaded extends WorkshopsState {
  final List<String> mechanical;

  MechanicalLoaded(this.mechanical);
}