import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/card_item.dart';
part 'cart_state.dart';

class CartLogic extends Cubit<CartState> {
  CartLogic() : super(CartInitial());

  List<CartItem> cartItems = [];

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

  void addToCart(CartItem cartItem) {
    final index = cartItems.indexWhere((item) => item.name == cartItem.name);

    if (index != -1) {
      // المنتج موجود → نزود الكمية
      cartItems[index].quantity += cartItem.quantity;
    } else {
      // المنتج جديد → نضيفه
      cartItems.add(cartItem);
    }

    emit(CartSuccess());
  }

  void removeItem(int id) {
    cartItems.removeWhere((item) => item.id == id);
    emit(CartSuccess());
  }
}
