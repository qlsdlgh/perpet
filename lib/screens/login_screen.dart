import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LogInState();
}

class _LogInState extends State<LoginScreen> {
  dynamic userInfo = '';
  String uid = '';
  dynamic currentUser = FirebaseAuth.instance.currentUser;
  FlutterSecureStorage storage =
      const FlutterSecureStorage(); // storage에 있는 유저 정보를 저장

  @override
  void initState() {
    super.initState();
  }

  Future<String> saveLoginInfo(String userUid) async {
    await storage.write(
      key: 'login',
      value: userUid,
    );
    userInfo = await storage.read(key: 'login');

    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/logo.png', scale: 1),
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
            // 이메일 로그인
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/email');
              },
              child: Image.asset(
                'assets/email_login.png',
                scale: 1.7,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // 구글 로그인
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/googlelogin.png',
                scale: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
