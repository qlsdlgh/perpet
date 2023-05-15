import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:perpet/screens/home_screen.dart';
//import 'package:perpet/screens/main_screen.dart';
import 'package:perpet/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:perpet/screens/main_screen.dart';
import 'package:perpet/screens/sign_up_pet_screen.dart';
import 'firebase_options.dart';

void main() async {
  kakao.KakaoSdk.init(nativeAppKey: '837a0a9f64bb0ab3fec2c0f449d4ea2e');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => const SignUpPet(),
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      // 로그인 정보 인증되면 MainScreen();
      //home: const MainScreen(),
      //home: Container(color: Colors.white, child: const LoginKakao()),
      home: const MainScreen(),
    );
  }
}
