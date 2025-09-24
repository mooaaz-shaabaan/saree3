part of 'cart_logic.dart';


abstract class CartState {}

final class CartInitial extends CartState {}

final class CartSuccess extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;

  CartUpdated(this.items);

  List<Object?> get props => [items];
}

final class CartFailure extends CartState {
  final String error;
  CartFailure(this.error);
}
