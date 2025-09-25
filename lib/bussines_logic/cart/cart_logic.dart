// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../model/cart_item.dart';
// import '../../model/prodact_model.dart';
// part 'cart_state.dart';

// enum AddToCartResult { added, increasedQuantity, differentRestaurant }

// class CartLogic extends Cubit<CartState> {
//   CartLogic() : super(CartInitial());

//   List<CartItem> cartItems = [];

//   Map<int, int> quantityPerItem = {};

//   int getQuantity(MenuItem item) {
//     return quantityPerItem[item.id] ?? 1;
//   }

//   void plusQuantity(MenuItem item) {
//     quantityPerItem[item.id] = getQuantity(item) + 1;
//     emit(CartUpdated(cartItems));
//   }

//   void minsQuantity(MenuItem item) {
//     final current = getQuantity(item);
//     if (current > 1) {
//       quantityPerItem[item.id] = current - 1;
//       emit(CartUpdated(cartItems));
//     }
//   }

//   double get totalAmount {
//     return cartItems.fold(
//       0.0,
//       (sum, item) => sum + (item.price * item.quantity),
//     );
//   }

//   void clearCart() {
//     cartItems.clear();
//     emit(CartUpdated(cartItems)); // علشان الـ UI يتحدث
//   }

//   AddToCartResult addMenuItemToCart(MenuItem menuItem) {
//     final cartItem = CartItem(
//       id: menuItem.id,
//       name: menuItem.name,
//       price: menuItem.price,
//       quantity: 1,
//       description: menuItem.description,
//       imageProdact: menuItem.imageProdact,
//       imageResturant: menuItem.imageResturant,
//       restaurantName: menuItem.restaurantName,
//       restaurantNameDefault: menuItem.restaurantNameDefault,
//     );

//     // ✅ لو السلة فاضية → ضيفه على طول
//     if (cartItems.isEmpty) {
//       cartItems.add(cartItem);
//       emit(CartSuccess());
//       return AddToCartResult.added;
//     }

//     // ✅ نجيب المطعم الأول الموجود في السلة
//     final currentRestaurant = cartItems.first.imageResturant;

//     // ❌ لو المنتج من مطعم مختلف → نرجع أنه مختلف
//     if (cartItem.imageResturant != currentRestaurant) {
//       return AddToCartResult.differentRestaurant;
//     }

//     // ✅ لو المنتج من نفس المطعم
//     final sameItemIndex = cartItems.indexWhere(
//       (item) => item.id == cartItem.id,
//     );

//     if (sameItemIndex != -1) {
//       // نفس المنتج موجود → نزود الكمية
//       cartItems[sameItemIndex].quantity += cartItem.quantity;
//       emit(CartSuccess());
//       return AddToCartResult.increasedQuantity;
//     } else {
//       // منتج جديد من نفس المطعم → نضيفه
//       cartItems.add(cartItem);
//       emit(CartSuccess());
//       return AddToCartResult.added;
//     }
//   }

//   void removeItem(int id) {
//     cartItems.removeWhere((item) => item.id == id);
//     emit(CartSuccess());
//   }

//   @override
//   Future<void> close() {
    
//     return super.close();
//   }
// }









import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/cart_item.dart';
import '../../model/prodact_model.dart';
part 'cart_state.dart';

enum AddToCartResult { added, increasedQuantity, differentRestaurant }

class CartLogic extends Cubit<CartState> {
  CartLogic() : super(CartInitial());

  List<CartItem> cartItems = [];

  // هنا نخزن الكمية لكل منتج بشكل مستقل
  Map<int, int> quantityPerItem = {};

  // جلب الكمية الحالية للمنتج
  int getQuantity(MenuItem item) {
    return quantityPerItem[item.id] ?? 1;
  }

  // زيادة الكمية
  void plusQuantity(MenuItem item) {
    final newQuantity = getQuantity(item) + 1;
    quantityPerItem[item.id] = newQuantity;

    // لو موجود في السلة حدث الكمية هناك كمان
    final index = cartItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      cartItems[index].quantity = newQuantity;
    }

    emit(CartUpdated(cartItems));
  }

  // نقص الكمية
  void minsQuantity(MenuItem item) {
    final current = getQuantity(item);
    if (current > 1) {
      final newQuantity = current - 1;
      quantityPerItem[item.id] = newQuantity;

      final index = cartItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        cartItems[index].quantity = newQuantity;
      }

      emit(CartUpdated(cartItems));
    }
  }

  // إجمالي السعر
  double get totalAmount {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  // مسح السلة
  void clearCart() {
    cartItems.clear();
    quantityPerItem.clear();
    emit(CartUpdated(cartItems));
  }

  // إضافة منتج للسلة
  AddToCartResult addMenuItemToCart(MenuItem menuItem) {
    final currentQuantity = quantityPerItem[menuItem.id] ?? 1;

    final cartItem = CartItem(
      id: menuItem.id,
      name: menuItem.name,
      price: menuItem.price,
      quantity: currentQuantity,
      description: menuItem.description,
      imageProdact: menuItem.imageProdact,
      imageResturant: menuItem.imageResturant,
      restaurantName: menuItem.restaurantName,
      restaurantNameDefault: menuItem.restaurantNameDefault,
    );

    // لو السلة فاضية → ضيفه على طول
    if (cartItems.isEmpty) {
      cartItems.add(cartItem);
      emit(CartSuccess());
      return AddToCartResult.added;
    }

    // نجيب المطعم الأول الموجود في السلة
    final currentRestaurant = cartItems.first.imageResturant;

    // لو المنتج من مطعم مختلف → نرجع أنه مختلف
    if (cartItem.imageResturant != currentRestaurant) {
      return AddToCartResult.differentRestaurant;
    }

    // لو المنتج من نفس المطعم
    final sameItemIndex = cartItems.indexWhere(
      (item) => item.id == cartItem.id,
    );

    if (sameItemIndex != -1) {
      // نفس المنتج موجود → نزود الكمية
      final newQuantity = cartItems[sameItemIndex].quantity + currentQuantity;
      cartItems[sameItemIndex].quantity = newQuantity;
      quantityPerItem[cartItem.id] = newQuantity;
      emit(CartSuccess());
      return AddToCartResult.increasedQuantity;
    } else {
      // منتج جديد من نفس المطعم → نضيفه
      cartItems.add(cartItem);
      emit(CartSuccess());
      return AddToCartResult.added;
    }
  }

  // إزالة عنصر من السلة
  void removeItem(int id) {
    cartItems.removeWhere((item) => item.id == id);
    quantityPerItem.remove(id);
    emit(CartSuccess());
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
