class DriverModel {
  String driverName, driverPhone, userUID, statusOrder;
  double lat = 0, lng = 0;
  Map cartItems;

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
    return DriverModel(
      userUID: map['userUID'] ?? "",
      lat: map['driver_lat'] ?? 0,
      lng: map['driver_long'] ?? 0,
      driverName: map['driverName'],
      driverPhone: map['phone'],
      cartItems: map['cartItems'],
      statusOrder: 'status',
    );
  }
}
