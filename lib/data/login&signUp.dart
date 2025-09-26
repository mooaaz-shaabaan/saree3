import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saree3/bottom_bar.dart';
import 'package:saree3/constants/constants.dart';
import 'package:saree3/presentation/screens/auth/login.dart';

Future<void> signUp({
  required String email,
  required String password,
  required String name,
  required BuildContext context,
}) async {
  try {
    UserCredential userCred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCred.user!.uid)
        .set({
          'uid': userCred.user!.uid,
          'email': email,
          'full_name': name,
          'phone_number': "16757",
          'bio': "I love saree3 app",
          'image': Images.firstImageProfile,
          'createdAt': FieldValue.serverTimestamp(),
        });

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: "Account registered successfully",
    ).show();

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  } on FirebaseAuthException catch (e) {
    String message = "Error, Please try again";
    switch (e.code) {
      case 'email-already-in-use':
        message = "This email is already in use.";
        break;
      case 'invalid-email':
        message = "The email you entered is not valid.";
        break;
      case 'operation-not-allowed':
        message = "Password sign-in is not enabled. Please contact support.";
        break;
      case 'weak-password':
        message = "The password is too weak. Try a stronger one.";
        break;
      case 'too-many-requests':
        message =
            "Too many attempts in a short time! Please wait and try again.";
        break;
      case 'user-token-expired':
        message = "Your session has expired. Please sign in again.";
        break;
      case 'network-request-failed':
        message = "No internet connection. Check your network and try again.";
        break;
      default:
        message = "Unexpected error: ${e.message}";
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: message,
    ).show();
  } catch (e) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: '$e',
    ).show();
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

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: "Successfully login your account.",
    ).show();

    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => BottomBar()),
    );
  } on FirebaseAuthException catch (e) {
    String message;

    switch (e.code) {
      case 'invalid-email':
        message = "The email you entered is not valid.";
        break;
      case 'user-disabled':
        message = "This account has been disabled. Please contact support.";
        break;
      case 'user-not-found':
        message = "No account found with this email.";
        break;
      case 'wrong-password':
        message = "Incorrect password. Please try again.";
        break;
      case 'too-many-requests':
        message =
            "Too many attempts in a short time! Please wait and try again.";
        break;
      case 'user-token-expired':
        message = "Your session has expired. Please sign in again.";
        break;
      case 'network-request-failed':
        message = "No internet connection. Please check your network.";
        break;
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        message = "Invalid login credentials.";
        break;
      case 'operation-not-allowed':
        message = "Password sign-in is not enabled. Please contact support.";
        break;
      default:
        message = "Unexpected error: ${e.message}";
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: message,
    ).show();
  } catch (e) {
    print("ERROR => $e");
  }
}

Future<void> logOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}
