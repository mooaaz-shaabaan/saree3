import 'package:flutter/material.dart';

class AddressModel {
  final String id;
  final String type;
  final int typeIndex;
  final String address;
  final IconData icon;
  final Color color;
  final double lat;
  final double lng;
  final String apartment;

  AddressModel({required this.id, 
    required this.apartment, 
    required this.lat,
    required this.lng,
    required this.type,
    required this.typeIndex,
    required this.address,
    required this.icon,
    required this.color,
  });
}
