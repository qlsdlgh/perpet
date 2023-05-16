import 'package:flutter/material.dart';
import 'package:perpet/service/main_view_model.dart';
import 'package:perpet/service/kakao_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LogInState();
}

class _LogInState extends State<LoginScreen> {
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/logo.png', scale: 0.9),
            const SizedBox(
              height: 15,
            ),
            const Text(
              '반려동물 통합 관리 앱 퍼펫',
              style: TextStyle(
                  color: Color(0xffFF8F9A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () async {
                await loginKakao();
                if (FirebaseAuth.instance.currentUser != null) {
                  if (!mounted) return;
                  Navigator.pushNamed(context, '/signup');
                }

                setState(() {});
              },
              child: Image.asset(
                'assets/kakaologin.png',
                width: 450,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                logoutKakao(); // 로그아웃 기능 테스트용
              },
              child: Image.asset(
                'assets/googlelogin.png',
                width: 450,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

loginKakao() async {
  final viewModel = MainViewModel(KakaoLogin());
  late final String uid;

  await viewModel.login();

  uid = FirebaseAuth.instance.currentUser!.uid;

  await storage.write(
    key: 'login',
    value: uid,
  );
}

logoutKakao() async {
  final viewModel = MainViewModel(KakaoLogin());
  await viewModel.logout();
  await storage.delete(key: 'login');
}
