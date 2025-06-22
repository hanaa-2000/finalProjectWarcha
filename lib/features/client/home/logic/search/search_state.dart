part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Map<String, dynamic>> allItems;
  final List<Map<String, dynamic>> filteredItems;

  SearchLoaded({required this.allItems, this.filteredItems = const []});
}

class SearchError extends SearchState {
  final String error;

  SearchError({required this.error});
}

class SearchFilterLoading extends SearchState {}

class SearchFilterLoaded extends SearchState {}

class SearchFilterError extends SearchState {
  final String message;
  SearchFilterError(this.message);
}