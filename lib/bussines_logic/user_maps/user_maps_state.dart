abstract class UserMapsStatee {}

class UserMapsInitial extends UserMapsStatee {}

class SetMapController extends UserMapsStatee {}

class MoveToUserPosition extends UserMapsStatee {}

class LoadMapStyle extends UserMapsStatee {}

class LoadIcon extends UserMapsStatee {}

class InitLocation extends UserMapsStatee {}

class CheckLocationPermission extends UserMapsStatee {}

class ListenToDrivers extends UserMapsStatee {}

class ErrorState extends UserMapsStatee {
  final String message;
  ErrorState(this.message);
}


