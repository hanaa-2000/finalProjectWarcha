part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class UserLoading extends ProfileState {}


class UserSuccess extends ProfileState {
  final ProfileUser user;
  UserSuccess(this.user);
}

class UserError extends ProfileState {
  final String message;
  UserError(this.message);
}

class UserUpdated extends ProfileState {}


class UserImageUpdated extends ProfileState {
  final String downloadImage;
  UserImageUpdated(this.downloadImage);
}


final class GetStartTimeLoading extends ProfileState {}

class GetStartTimeSuccess extends ProfileState {
  final String startTime;

  GetStartTimeSuccess(this.startTime);
}
final class GetStartTimeFailure extends ProfileState {}

final class GetEndTimeLoading extends ProfileState {}

class GetEndTimeSuccess extends ProfileState {
  final String endTime;

  GetEndTimeSuccess(this.endTime);
}
final class GetEndTimeFailure extends ProfileState {}
