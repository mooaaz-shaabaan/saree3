import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/prodact_model.dart';
part 'favorite_state.dart';

class FavoriteLogic extends Cubit<FavoriteState> {
  FavoriteLogic() : super(FavoriteInitial());

  List<MenuItem> favorites = [];
  Map<int, int> quantityPerItem = {};

  int getQuantity(MenuItem item) {
    return quantityPerItem[item.id] ?? 1;
  }

  void plusQuantity(MenuItem item) {
    quantityPerItem[item.id] = getQuantity(item) + 1;
    emit(FavoriteSuccess());
  }

  void minsQuantity(MenuItem item) {
    final current = getQuantity(item);
    if (current > 1) {
      quantityPerItem[item.id] = current - 1;
      emit(FavoriteSuccess());
    }
  }

  bool isFavoriteItem(MenuItem item) {
    return favorites.any((element) => element.id == item.id);
  }

  void addToFavorite(MenuItem menuItem, BuildContext context) {
    final exists = isFavoriteItem(menuItem);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${menuItem.name} is already in Favorites'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      favorites.add(menuItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${menuItem.name} added to Favorites'),
          duration: const Duration(seconds: 1),
        ),
      );
      emit(FavoriteSuccess());
    }
  }

  void removeItemById(int id) {
    favorites.removeWhere((item) => item.id == id);
    emit(FavoriteSuccess());
  }

  void toggleFavorite(MenuItem menuItem, BuildContext context) {
    if (isFavoriteItem(menuItem)) {
      removeItemById(menuItem.id);
    } else {
      addToFavorite(menuItem, context);
    }
  }
}
