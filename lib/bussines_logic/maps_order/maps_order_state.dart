part of 'maps_order_cubit.dart';

abstract class MapsOrderState {}

class MapsOrderInitial extends MapsOrderState {}

class ListenToOrders extends MapsOrderState {}

class ErrorState extends MapsOrderState {}
