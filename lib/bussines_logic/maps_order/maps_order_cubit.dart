// import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:saree3/model/driverModel.dart';

part 'maps_order_state.dart';

class MapsOrderLogic extends Cubit<MapsOrderState> {
  MapsOrderLogic() : super(MapsOrderInitial());

  void initialize() {
    _listenToOrders();
  }

  DriverModel? currentOrder;

  bool isLoading = true;
  String? error;
  // StreamSubscription? _subscription;

  void _listenToOrders() {
    final ref = FirebaseDatabase.instance.ref("orders");
    String userUID = FirebaseAuth.instance.currentUser!.uid;

    ref.onValue.listen(
      (event) {
        try {
          isLoading = false; 
          error = null;

          if (event.snapshot.value == null) {
            currentOrder = null;
            emit(ListenToOrders());
            return;
          }

          final rawData = event.snapshot.value as Map<dynamic, dynamic>;
          DriverModel? userOrder;

          for (var entry in rawData.entries) {
            // حول كل key لـ String
            final safeMap = (entry.value as Map<dynamic, dynamic>).map(
              (key, value) => MapEntry(key.toString(), value),
            );

            final model = DriverModel.fromMap(safeMap);
            if (model.userUID == userUID) {
              userOrder = model;
              break;
            }
          }

          currentOrder = userOrder;
          emit(ListenToOrders());
        } catch (e) {
          isLoading = false;
          error = e.toString();
          print(e);
          emit(ErrorState());
        }
      },
      onError: (error) {
        isLoading = false;
        this.error = error.toString();
        emit(ErrorState());
      },
    );
  }
}
