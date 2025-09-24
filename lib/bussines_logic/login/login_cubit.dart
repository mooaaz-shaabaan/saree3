import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saree3/bussines_logic/login/login_state.dart';

class LoginLogic extends Cubit<LoginState> {
  LoginLogic() : super(LoginInitial());
  bool rememberMe = false;
  bool obSecure = true;

  void showPassword() {
    obSecure = !obSecure;
    emit(ShowPassword());
  }

  void rememberrMe(bool v) {
    rememberMe = v;
    emit(ShowPassword());
  }
}
