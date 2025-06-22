part of 'favorite_cubit.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<WorkshopModel> favorites;

  FavoriteLoaded(this.favorites);
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);
}
