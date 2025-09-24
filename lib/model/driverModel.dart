class DriverModel {
  // final String driverUID, driver_name, userUID;
  String userUID = '';
  double lat = 0, lng = 0;

  DriverModel({
    required this.userUID,
    // required this.driver_name,
    // required this.driverUID,
    required this.lat,
    required this.lng,
  });

  factory DriverModel.fromMap(Map<dynamic, dynamic> map) {
    return DriverModel(
      userUID: map['userUID'] ?? "",
      // driverUID: map['driverUID'],
      lat: map['lat'] ?? 0,
      lng: map['lng'] ?? 0,
      // driver_name: map['driver_name'],
    );
  }
}

