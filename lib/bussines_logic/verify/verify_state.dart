abstract class VerifyState {}

class VerifyInitial extends VerifyState {}

class VerifyChanged extends VerifyState {
  final int secondsRemaining;
  VerifyChanged(this.secondsRemaining);
}

class VerifyFinished extends VerifyState {}
