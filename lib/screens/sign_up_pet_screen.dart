import 'package:flutter/material.dart';

import 'inputPet.dart';

//회원가입 화면
//로그 인 후에는 앱 켤떄 안보이게 하기
class SignUpPetScreen extends StatefulWidget {
  const SignUpPetScreen({Key? key}) : super(key: key);

  @override
  State<SignUpPetScreen> createState() => _SignUpPetScreen();
}

class _SignUpPetScreen extends State<SignUpPetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "회원가입",
          ),
          backgroundColor: Colors.pink[100],
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
          bottomOpacity: 15,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const InputPet(),
              const SizedBox(
                height: 40.0,
              ),
              ButtonTheme(
                  minWidth: 100.0,
                  height: 50.0,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 14, color: Colors.white)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink[100])),
                      child: const Text("완료"),
                      onPressed: () {
                        //정보 기입 완료 버튼을 눌렀을 때 실행될 코드
                        //정보를 저장하고 다시 로그인 화면으로 이동하기
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }))
            ],
          ),
        ));
  }
}
