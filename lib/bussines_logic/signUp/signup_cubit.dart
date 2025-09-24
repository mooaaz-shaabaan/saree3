import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_state.dart';

class SignUpLogic extends Cubit<SignUpState> {
  SignUpLogic() : super(SignUpInitial());
  String? selectedGender;
  bool obSecure = true;
  bool reObSecure = true;
  final List<String> genders = ["Male", "Female", "Rather not Say"];

  void showPassword() {
    obSecure = !obSecure;
    emit(ShowPassword());
  }

  void showRePassword() {
    reObSecure = !reObSecure;
    emit(ShowPassword());
  }

  void updateGender(String? val){
     selectedGender = val;
  }
}
