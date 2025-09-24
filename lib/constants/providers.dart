import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saree3/bussines_logic/auth/auth_logic.dart';
import 'package:saree3/bussines_logic/maps_order/maps_order_cubit.dart';
import 'package:saree3/bussines_logic/tracking_order_map/tracking_order_map_cubit.dart';
import 'package:saree3/bussines_logic/user_maps/user_maps_cubit.dart';

import '../bussines_logic/address/address_cubit.dart';
import '../bussines_logic/cart/cart_logic.dart';
import '../bussines_logic/data_user/data_user_cubit.dart';
import '../bussines_logic/favorite/favorite_cubit.dart';
import '../bussines_logic/login/login_cubit.dart';
import '../bussines_logic/signUp/signup_cubit.dart';
import '../bussines_logic/verify/verify_cubit.dart';

class AppProviders {
  static get providers => [
    BlocProvider<CartLogic>(create: (_) => CartLogic()),
    BlocProvider<AddressLogic>(create: (_) => AddressLogic()),
    BlocProvider<FavoriteLogic>(create: (_) => FavoriteLogic()),
    BlocProvider<LoginLogic>(create: (_) => LoginLogic()),
    BlocProvider<SignUpLogic>(create: (_) => SignUpLogic()),
    BlocProvider<VerifyLogic>(create: (_) => VerifyLogic()),
    BlocProvider<AuthLogic>(create: (_) => AuthLogic()),
    BlocProvider<DataUserLogic>(
      create: (_) {
        final cubit = DataUserLogic();
        cubit.initialize();
        return cubit;
      },
    ),
    BlocProvider<MapsOrderLogic>(
      create: (_) {
        final cubit = MapsOrderLogic();
        cubit.initialize();
        return cubit;
      },
    ),
    BlocProvider<UserMapsLogic>(
      create: (_) {
        final cubit = UserMapsLogic();
        cubit.initialize();
        return cubit;
      },
    ),
    BlocProvider<TrackingOrderMapLogic>(
      create: (_) {
        final cubit = TrackingOrderMapLogic();
        cubit.initialize();
        return cubit;
      },
    ),
  ];
}
