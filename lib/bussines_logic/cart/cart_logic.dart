import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/card_item.dart';
import '../../model/prodact_model.dart';
part 'cart_state.dart';

enum AddToCartResult { added, increasedQuantity, differentRestaurant }

class CartLogic extends Cubit<CartState> {
  CartLogic() : super(CartInitial());

  List<CartItem> cartItems = [];

  Map<int, int> quantityPerItem = {};

  int getQuantity(MenuItem item) {
    return quantityPerItem[item.id] ?? 1;
  }

  void plusQuantity(MenuItem item) {
    quantityPerItem[item.id] = getQuantity(item) + 1;
    emit(CartUpdated(cartItems));
  }

  void minsQuantity(MenuItem item) {
    final current = getQuantity(item);
    if (current > 1) {
      quantityPerItem[item.id] = current - 1;
      emit(CartUpdated(cartItems));
    }
  }

  double get totalAmount {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void clearCart() {
    cartItems.clear();
    emit(CartUpdated(cartItems)); // علشان الـ UI يتحدث
  }

  AddToCartResult addMenuItemToCart(MenuItem menuItem) {
    final cartItem = CartItem(
      id: menuItem.id,
      name: menuItem.name,
      price: menuItem.price,
      quantity: 1,
      description: menuItem.description,
      imageProdact: menuItem.imageProdact,
      imageResturant: menuItem.imageResturant,
      restaurantName: menuItem.restaurantName,
      restaurantNameDefault: menuItem.restaurantNameDefault,
    );

    // ✅ لو السلة فاضية → ضيفه على طول
    if (cartItems.isEmpty) {
      cartItems.add(cartItem);
      emit(CartSuccess());
      return AddToCartResult.added;
    }

    // ✅ نجيب المطعم الأول الموجود في السلة
    final currentRestaurant = cartItems.first.imageResturant;

    // ❌ لو المنتج من مطعم مختلف → نرجع أنه مختلف
    if (cartItem.imageResturant != currentRestaurant) {
      return AddToCartResult.differentRestaurant;
    }

    // ✅ لو المنتج من نفس المطعم
    final sameItemIndex = cartItems.indexWhere(
      (item) => item.id == cartItem.id,
    );

    if (sameItemIndex != -1) {
      // نفس المنتج موجود → نزود الكمية
      cartItems[sameItemIndex].quantity += cartItem.quantity;
      emit(CartSuccess());
      return AddToCartResult.increasedQuantity;
    } else {
      // منتج جديد من نفس المطعم → نضيفه
      cartItems.add(cartItem);
      emit(CartSuccess());
      return AddToCartResult.added;
    }
  }

  void removeItem(int id) {
    cartItems.removeWhere((item) => item.id == id);
    emit(CartSuccess());
  }
}
