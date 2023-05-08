import 'package:flutter/material.dart';

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
              TextButton.icon(
                icon: const Icon(Icons.message),
                label: const Text(
                  '카카오톡으로 로그인',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xffF7E600)),
                  foregroundColor: MaterialStateProperty.all(
                    const Color(0xff3A1D1D),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 130,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton.icon(
                icon: const Icon(Icons.message),
                label: const Text(
                  '구글계정으로 로그인',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(
                    const Color(0xff3A1D1D),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 130,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.grey,
                        )),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
