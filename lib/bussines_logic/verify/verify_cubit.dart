import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'verify_state.dart';

class VerifyLogic extends Cubit<VerifyState> {
  VerifyLogic() : super(VerifyInitial()) {
    startTimer(); // 👈 يبدأ أول ما يتبني Cubit
  }

  Timer? timer;
  int secondsRemaining = 50;

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        emit(VerifyChanged(secondsRemaining));
      } else {
        timer.cancel();
        emit(VerifyFinished());
      }
    });
  }

  void resetTimer() {
    secondsRemaining = 50;
    emit(VerifyChanged(secondsRemaining));
    startTimer();
  }
}
