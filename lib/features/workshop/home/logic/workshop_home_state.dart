part of 'workshop_home_cubit.dart';

@immutable
sealed class WorkshopHomeState {}

final class WorkshopHomeInitial extends WorkshopHomeState {}
class MechanicalLoading extends WorkshopHomeState {}

class MechanicalAdded extends WorkshopHomeState {}

class MechanicalError extends WorkshopHomeState {
  final String message;

  MechanicalError(this.message);
}

class MechanicalLoaded extends WorkshopHomeState {
  final List<String> mechanical;

  MechanicalLoaded(this.mechanical);
}
// // حالة جديدة لتحميل الأشخاص والأسماء المختارة
// class MechanicalLoadedWithPeople extends PersonState {
//   final List<String> people;
//   final List<String> selectedNames;
//
//   MechanicalLoadedWithPeople(this.people, this.selectedNames);
//}

class OrdersLoading extends WorkshopHomeState {}

class OrderLoaded extends WorkshopHomeState {
  final List<AppointmentModel> order;
  OrderLoaded(this.order);
}

class NoOrderFound extends WorkshopHomeState {}

class OrdersError extends WorkshopHomeState {
  final String errMsg;
  OrdersError(this.errMsg);
}