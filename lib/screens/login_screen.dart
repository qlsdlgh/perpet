import 'package:flutter/material.dart';
import 'package:perpet/screens/sign_up_user_screen.dart';

import 'main_screen.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: (EdgeInsets.only(top: 100)),
            ),
            const Center(
              child: Image(
                image: AssetImage('picture/고슴도치.jpg'), // 나중에 로고로 바꾸기
                width: 170,
                height: 190,
              ),
            ),
            Form(
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.teal,
                  inputDecorationTheme: const InputDecorationTheme(
                      labelStyle:
                          TextStyle(color: Colors.teal, fontSize: 15.0)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (text) {
                          setState(() {
                            id = text;
                          });
                        },
                        //아이디가 입력되는 칸
                        decoration: const InputDecoration(labelText: 'ID'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        onChanged: (text) {
                          setState(() {
                            pass = text;
                          });
                        },
                        //비밀번호가 입력되는 칸
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonTheme(
                              // 로그인 버튼
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      textStyle: MaterialStateProperty.all(
                                          const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.pink[100])),
                                  child: const Text("Log in"),
                                  onPressed: () {
                                    //로그인 버튼을 눌렀을 때 작동될 코드
                                    //정보가 맞다면
                                    //홈 화면으로 이동
                                    //정보가 틀리다면
                                    //틀렸다고 팝업 띄우기
                                    if (id == testId || pass == testPass) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const MainScreen()));
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible:
                                              true, // 바깥 영역 터치시 닫을지 여부
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  "아이디와 비밀번호를 입력해 주세요"),
                                              insetPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 80, 0, 80),
                                              actions: [
                                                TextButton(
                                                  child: const Text('확인'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  })),
                          const SizedBox(
                            width: 15,
                          ),
                          ButtonTheme(
                              // 회원가입 버튼
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      textStyle: MaterialStateProperty.all(
                                          const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.pink[100])),
                                  child: const Text("Sign up"),
                                  onPressed: () {
                                    //회원가입 화면으로 넘어가기
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpUserScreen()),
                                    );
                                  })),
                        ],
                      ),
                      ButtonTheme(
                          // 카카오로 로그인하는 버튼
                          minWidth: 100.0,
                          height: 50.0,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.pink[100])),
                              child: const Text("Log in for Kakao"),
                              onPressed: () {
                                //여기에 카카오 코드 입력하시면 될거같아요!
                              }))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
