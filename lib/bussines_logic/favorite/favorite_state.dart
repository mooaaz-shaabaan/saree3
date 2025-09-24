part of 'favorite_cubit.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteSuccess extends FavoriteState {}

final class FavoriteFailure extends FavoriteState {
  final String error;
  FavoriteFailure(this.error);
}
