abstract class AuthState {}

class AuthInitial extends AuthState {}

// Signup States
class SignupLoading extends AuthState {}
class SignupSuccess extends AuthState {}
class SignupFailure extends AuthState {
  final String message;
  SignupFailure(this.message);
}

// Login States
class LoginLoading extends AuthState {}
class LoginSuccess extends AuthState {
  final String uid;
  LoginSuccess(this.uid);
}
class LoginFailure extends AuthState {
  final String message;
  LoginFailure(this.message);
}

// Logout
class LogoutSuccess extends AuthState {}
