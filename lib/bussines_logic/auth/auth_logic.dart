import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saree3/bottom_bar.dart';
import 'package:saree3/bussines_logic/auth/auth_state.dart';
import 'package:saree3/presentation/screens/auth/login.dart';

class AuthLogic extends Cubit<AuthState> {
  AuthLogic() : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String image =
        "https://firebasestorage.googleapis.com/v0/b/saree3-6a6dc.firebasestorage.app/o/Profile%20User%2FMoaz%20B-Badla.jpg?alt=media&token=08dcf6fd-79ca-4739-8984-0cebd115a583", // خليها ثابت في constants.dart
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
            'name': name,
            'image': image,
            'createdAt': FieldValue.serverTimestamp(),
          });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: "تم تسجيل الحساب بنجاح",
        btnOkOnPress: () {
          logOut(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ).show();

      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code, fallback: e.message);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: message,
      ).show();
      emit(SignupFailure(message));
    } catch (e) {
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
    emit(LoginLoading());
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCred.user!.uid;

      


      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: "تم تسجيل الدخول الى حسابك بنجاح",
      ).show();

      emit(LoginSuccess(uid));

      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomBar()),
      );
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code, fallback: e.message);

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: message,
      ).show();

      emit(LoginFailure(message));
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "$e",
      ).show();

      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // بعد ما يخلص تسجيل الخروج → يرجع على صفحة Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    emit(LogoutSuccess());
  }

  // جوه class AuthLogic
  String _getAuthErrorMessage(String code, {String? fallback}) {
    switch (code) {
      case 'email-already-in-use':
        return "الإيميل ده مستخدم بالفعل.";
      case 'invalid-email':
        return "الإيميل اللي دخلته غير صالح.";
      case 'operation-not-allowed':
        return "التسجيل بالباسورد مش مفعّل، تواصل مع الدعم.";
      case 'weak-password':
        return "الباسورد ضعيف جدًا، جرب حاجة أقوى.";
      case 'too-many-requests':
        return "محاولات كتير في وقت قصير! استنى شوية وحاول تاني.";
      case 'user-token-expired':
        return "انتهت صلاحية الجلسة، سجل دخول من جديد.";
      case 'network-request-failed':
        return "مفيش اتصال بالإنترنت. اتأكد من الشبكة.";
      case 'user-disabled':
        return "الحساب ده متعطل، تواصل مع الدعم.";
      case 'user-not-found':
        return "مفيش حساب مسجل بالإيميل ده.";
      case 'wrong-password':
        return "الباسورد غلط، حاول تاني.";
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return "بيانات الدخول غير صحيحة.";
      default:
        return fallback ?? "حصل خطأ غير متوقع.";
    }
  }
}
