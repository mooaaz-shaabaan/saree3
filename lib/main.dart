import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saree3/bottom_bar.dart';
import 'constants/providers.dart';
import 'firebase_options.dart';
import 'presentation/screens/auth/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Init Error: $e");
  }

  runApp(
    MultiBlocProvider(providers: AppProviders.providers , child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool checkLogin = FirebaseAuth.instance.currentUser != null;
    return ScreenUtilInit( 
      designSize: const Size(392, 872),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Saree3",
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: "sen",
          ),
          home: child,
        );
      },
      child: checkLogin ? BottomBar() : LoginPage(),
    );
  }
}

/*
  flutter clean
  flutter pub cache repair

  flutter clean
  flutter pub get 
  flutter build apk --release
  flutter run --release
*/

/*
git add .
git commit -m "tkmla elProject" 
git push origin main
*/

/*
  final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userUID = currentUser.uid;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
*/

/*
  behavior: HitTestBehavior.opaque,
  onTap: () => FocusScope.of(context).unfocus(),
*/