import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saree3/bussines_logic/address/address_state.dart';

import '../../model/address/address_model.dart';

class AddressLogic extends Cubit<AddressState> {
  AddressLogic() : super(AddressInitial()) {
    addressSelected = '${addresses[0].type} , ${addresses[0].address}';
    addressSelectedLat = addresses[0].lat;
    addressSelectedLng = addresses[0].lng;
  }

  final List<AddressModel> addresses = [
    AddressModel(
      id: '1',
      type: 'HOME',
      typeIndex: 0,
      address: '2464 Royal Ln. Mesa, New Jersey 45463',
      icon: Icons.home_outlined,
      color: Colors.blue,
      lat: 30.0537864719637,
      lng: 31.33843323998014,
      apartment: '5',
    ),
    AddressModel(
      id: '2',
      type: 'WORK',
      typeIndex: 1,
      address: '3891 Ranchview Dr. Richardson, California 62639',
      icon: Icons.work_outline,
      color: Colors.purple,
      lat: 30.020397852475888,
      lng: 31.22251388824806,
      apartment: '3',
    ),
  ];
  int isSelected = 0;
  String? addressSelected;
  double? addressSelectedLat;
  double? addressSelectedLng;

  void updateAddress(String? id) {
    if (id == null) return;
    int index = addresses.indexWhere((address) => address.id == id);
    if (index != -1) {
      addressSelected =
          '${addresses[index].type} , ${addresses[index].address}';
      addressSelectedLat = addresses[index].lat;
      addressSelectedLng = addresses[index].lng;
      isSelected = index;
      emit(AddressChanged());
    }
  }

  void updateIsSelected(int i) {
    isSelected = i;
    emit(AddressChanged());
  }

  void addAddress(AddressModel address) {
    addresses.add(address);
    emit(AddressChanged()); // نبلغ الـ UI إن فيه تغيير
  }

  void editAddress(int index, AddressModel newAddress) {
    addresses[index] = newAddress;
    emit(AddressChanged());
  }

  void removeAddress(int index) {
    addresses.removeAt(index);
    emit(AddressChanged());
  }
}
