import 'package:saree3/model/cart_item.dart';

class DriverModel {
  String driverName, driverPhone, userUID, statusOrder;
  double lat = 0, lng = 0;
  List<CartItem> cartItems;

  DriverModel({
    required this.statusOrder,
    required this.cartItems,
    required this.driverPhone,
    required this.userUID,
    required this.driverName,
    required this.lat,
    required this.lng,
  });

  factory DriverModel.fromMap(Map<dynamic, dynamic> map) {
    final safeMap = map.map((key, value) => MapEntry(key.toString(), value));

    List<CartItem> items = [];
    if (safeMap['cartItems'] != null) {
      final rawItems = safeMap['cartItems'] as List<dynamic>;
      items =
          rawItems
              .map(
                (e) => CartItem.fromMap(
                  (e as Map<dynamic, dynamic>).map(
                    (k, v) => MapEntry(k.toString(), v),
                  ),
                ),
              )
              .toList() ??
          [];
    }

    return DriverModel(
      userUID: safeMap['userUID'] ?? "",
      lat: (safeMap['driver_lat'] ?? 0).toDouble(),
      lng: (safeMap['driver_long'] ?? 0).toDouble(),
      driverName: safeMap['driverName'] ?? "",
      driverPhone: safeMap['phone'] ?? "",
      cartItems: items,
      statusOrder: safeMap['status'] ?? "",
    );
  }
}
