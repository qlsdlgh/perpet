import 'package:flutter/material.dart';
import 'package:perpet/service/main_view_model.dart';

//로그 인 후에는 앱 켤떄 안보이게 하기
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LogInState();
}

class _LogInState extends State<LoginScreen> {
  var id = "";
  var pass = "";
  var testId = "id";
  var testPass = "pass";

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
              const LoginKakao(),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/googlelogin.png',
                width: 450,
              ),
            ],
          ),
        ));
  }
}
