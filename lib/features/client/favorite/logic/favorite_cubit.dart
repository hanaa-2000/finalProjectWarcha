import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:warcha_final_progect/features/client/home/data/workshop_model.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get userId => _firebaseAuth.currentUser!.uid;

  Future<void> loadFavorites() async {
    emit(FavoriteLoading());
    try {
      final doc = await _firestore.collection('favorites').doc(userId).get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['favorites'] != null) { // Crucial check
          final favorites = (data['favorites'] as List<dynamic>)
              .map((item) => WorkshopModel.simpleFromJson(item as Map<String, dynamic>))
              .toList();
          emit(FavoriteLoaded(favorites));
        } else {
          // Handle case where 'favorites' list is empty or null.  Crucially important.
          emit(FavoriteLoaded([]));
        }
      } else {
        // Handle the case where the document doesn't exist
        emit(FavoriteLoaded([])); // Or emit an appropriate error state.
      }
    } catch (e) {
      emit(FavoriteError('حدث خطأ أثناء تحميل المفضلة: $e')); // Include the error message
      //  Crucial: Print to console for debugging purposes.
      print('Error loading favorites: $e');
    }
  }



  Future<void> toggleFavorite(WorkshopModel product) async {
    try {
      if (state is FavoriteLoaded) {
        final currentFavorites = (state as FavoriteLoaded).favorites;
        List<WorkshopModel> updatedFavorites = List.from(currentFavorites);

        final exists = updatedFavorites.any((element) => element.id == product.id);

        if (exists) {
          updatedFavorites.removeWhere((element) => element.id == product.id);
        } else {
          updatedFavorites.add(product);
        }

        await _firestore.collection('favorites').doc(userId).set({
          'favorites': updatedFavorites.map((e) => e.toJson()).toList(),
        });

        emit(FavoriteLoaded(updatedFavorites));
      }
    } catch (e) {
      emit(FavoriteError('حدث خطأ أثناء تعديل المفضلة'));
    }
  }

  bool isFavorite(String productId) {
    if (state is FavoriteLoaded) {
      return (state as FavoriteLoaded).favorites.any((element) => element.id == productId);
    }
    return false;
  }
}
