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
  // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'login');

    /*
    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      Navigator.pushNamed(context, '/home');
    } else {
      print('로그인이 필요합니다');
    }
    */
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
                Navigator.pushNamed(context, '/home');
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
  late final uid;

  await viewModel.login();
  /* secure storage에 login 정보 저장하는 부분
  User? currentUser = FirebaseAuth.instance.currentUser;
  uid = FirebaseAuth.instance.currentUser?.uid;

  if (currentUser != null) {
    await storage.write(
      key: 'login',
      value: uid,
    );
  }
  */
}
