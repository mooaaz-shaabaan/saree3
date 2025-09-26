import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saree3/presentation/screens/auth/login.dart';
import 'package:saree3/presentation/screens/maps/tracking_order_maps.dart';
import 'package:saree3/presentation/screens/maps/user_maps.dart';

import '../../../bussines_logic/maps_order/maps_order_cubit.dart';

class MapsOreder extends StatefulWidget {
  const MapsOreder({super.key});

  @override
  State<MapsOreder> createState() => MapsOrederState();
}

class MapsOrederState extends State<MapsOreder> {
  String? userUID;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userUID = currentUser.uid;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapsOrderLogic, MapsOrderState>(
      builder: (context, state) {
        print("??????????????????????????????????????????????? $state");
        final objMapsOrder = context.read<MapsOrderLogic>();
        print(
          "????????????????????***??????????????????????????? ${objMapsOrder.error}",
        );
        if (state is ErrorState) {
          return Scaffold(
            body: Center(child: Text("Error: ${objMapsOrder.error}")),
          );
        }

        // if (state is ListenToOrders) {
        //   return Scaffold(
        //     body: context.read<MapsOrderLogic>().currentOrder == null
        //         ? const UserMaps()
        //         : const TrackingOrderMaps(),
        //   );
        // }

        if (state is MapsOrderInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: context.read<MapsOrderLogic>().currentOrder == null
              ? const UserMaps()
              : const TrackingOrderMaps(),
        );
      },
    );
  }
}
