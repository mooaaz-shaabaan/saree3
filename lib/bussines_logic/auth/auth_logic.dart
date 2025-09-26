import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saree3/bottom_bar.dart';
import 'package:saree3/bussines_logic/auth/auth_state.dart';
import 'package:saree3/constants/constants.dart';
import 'package:saree3/presentation/screens/auth/login.dart';

class AuthLogic extends Cubit<AuthState> {
  AuthLogic() : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    emit(SignupLoading());
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('User Account')
          .doc(userCred.user!.uid)
          .set({
            'uid': userCred.user!.uid,
            'email': email,
            'full_name': name,
            'phone_number': "16757", // يفضل تكون في constants.dart
            'bio': "I love saree3 app", // برضه يفضل تبقى constant
            'image': Images.firstImageProfile,
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (!context.mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: "Account created successfully",
      ).show();
      Future.delayed(Duration(seconds: 3), () {
        logOut(context);
      });

      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code, fallback: e.message);

      if (!context.mounted) return;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: message,
      ).show();

      emit(SignupFailure(message));
    } catch (e) {
      if (!context.mounted) return;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: '$e',
      ).show();
      emit(SignupFailure(e.toString()));
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!context.mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: "Logged in successfully.",
      ).show();

      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomBar()),
      );
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code, fallback: e.message);

      if (!context.mounted) return;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: message,
      ).show();
    } catch (e) {
      if (!context.mounted) return;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "Unexpected error: $e",
      ).show();
    }
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    emit(LogoutSuccess());
  }

  String _getAuthErrorMessage(String code, {String? fallback}) {
    switch (code) {
      case 'email-already-in-use':
        return "This email is already in use.";
      case 'invalid-email':
        return "The email you entered is not valid.";
      case 'operation-not-allowed':
        return "Password sign-up is not enabled. Please contact support.";
      case 'weak-password':
        return "The password is too weak. Please choose a stronger one.";
      case 'too-many-requests':
        return "Too many attempts in a short time! Please wait and try again.";
      case 'user-token-expired':
        return "Your session has expired. Please sign in again.";
      case 'network-request-failed':
        return "No internet connection. Please check your network.";
      case 'user-disabled':
        return "This account has been disabled. Please contact support.";
      case 'user-not-found':
        return "No account found with this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return "Invalid login credentials.";
      default:
        return fallback ?? "An unexpected error occurred.";
    }
  }
}
