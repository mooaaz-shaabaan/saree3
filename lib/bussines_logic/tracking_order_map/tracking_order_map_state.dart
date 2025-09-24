part of 'tracking_order_map_cubit.dart';

abstract class TrackingOrderMapState {}

class TrackingInitial extends TrackingOrderMapState {}

class SetMapController extends TrackingOrderMapState {}

class LoadMapStyle extends TrackingOrderMapState {}

class LoadIcon extends TrackingOrderMapState {}

class ListenToLocations extends TrackingOrderMapState {}

class InitLocation extends TrackingOrderMapState {}

class GetPolyPoints extends TrackingOrderMapState {}

class FormatMinutes extends TrackingOrderMapState {}

class FitCameraToBounds extends TrackingOrderMapState {}

class ErrorState extends TrackingOrderMapState {
  final String message;
  ErrorState(this.message);
}
