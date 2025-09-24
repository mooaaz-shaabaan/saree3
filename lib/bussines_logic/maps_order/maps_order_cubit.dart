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

    // _subscription =
    ref.onValue.listen(
      (event) {
        try {
          isLoading = false;
          error = null;

          if (event.snapshot.value == null) {
            currentOrder = null;
            emit(ListenToOrders()); // اعمل emit حتى لو مفيش داتا

            return;
          }

          final data = event.snapshot.value as Map<dynamic, dynamic>;
          DriverModel? userOrder;

          for (var entry in data.entries) {
            final model = DriverModel.fromMap(entry.value);
            if (model.userUID == userUID) {
              userOrder = model;
              break; // ✅ اخرج من الـ loop لما تلاقي المطلوب
            }
          }

          currentOrder = userOrder;
          emit(ListenToOrders());
        } catch (e) {
          isLoading = false;
          error = e.toString();
          emit(ErrorState());
        }
      },
      onError: (error) {
        isLoading = false;
        this.error = error.toString();
      },
    );
  }
}
