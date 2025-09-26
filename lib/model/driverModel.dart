import 'package:saree3/model/cart_item.dart';

class DriverModel {
  final String driverName, driverPhone, userUID, statusOrder, totalPrice;
  final double lat;
  final double lng;
  final List<CartItem> cartItems;

  DriverModel({
    required this.totalPrice,
    required this.driverName,
    required this.driverPhone,
    required this.userUID,
    required this.statusOrder,
    required this.lat,
    required this.lng,
    required this.cartItems,
  });

  factory DriverModel.fromMap(Map<dynamic, dynamic> map) {
    final safeMap = map.map((key, value) => MapEntry(key.toString(), value));

    final rawItems = safeMap['cartItems'] as List<dynamic>? ?? [];
    final items = rawItems.map((e) {
      final itemMap = (e as Map<dynamic, dynamic>).map(
        (k, v) => MapEntry(k.toString(), v),
      );
      return CartItem.fromMap(itemMap);
    }).toList();

    return DriverModel(
      userUID: safeMap['userUID'] ?? "",
      lat: (safeMap['driver_lat'] ?? 0).toDouble(),
      lng: (safeMap['driver_long'] ?? 0).toDouble(),
      driverName: safeMap['driver_name'] ?? "",
      driverPhone: safeMap['phone'] ?? "",
      cartItems: items,
      statusOrder: safeMap['status'] ?? "",
      totalPrice: map['totalPrice'] ?? "",
    );
  }
}
