part of 'profile_client_cubit.dart';

@immutable
sealed class ProfileClientState {}

final class ProfileClientInitial extends ProfileClientState {}


class ClientLoading extends ProfileClientState {}

class ClientLoaded extends ProfileClientState {
  final ProfileClientModel client;
  ClientLoaded(this.client);
}

class ClientError extends ProfileClientState {
  final String message;
  ClientError(this.message);
}

class ClientSuccess extends ProfileClientState {

}

class UserUpdated extends ProfileClientState {}


class UserImageUpdated extends ProfileClientState {
  final String downloadImage;
  UserImageUpdated(this.downloadImage);
}

