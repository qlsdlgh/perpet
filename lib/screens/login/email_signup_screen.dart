import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perpet/screens/login/sign_up_pet_screen.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  bool isEmailError = false, isPassError = false;
  String emailError = '', passError = '';

  Future<void> signUpWithEmail() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 회원가입 성공
      isEmailError = false;
      isPassError = false;
      Fluttertoast.showToast(msg: '회원가입 성공');

      final currentUser = _auth.currentUser;
      saveUserInfo(currentUser!.uid, currentUser.email, currentUser.email);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SignUpPet(
                    currentUser: currentUser,
                  )),
          (route) => false);

      setState(() {});
    } on FirebaseAuthException catch (e) {
      // 회원가입 실패
      if (e.code == 'email-already-in-use') {
        setState(() {
          emailError = '이미 존재하는 이메일입니다.';
          isEmailError = true;
          isPassError = false;
        });
      } else if (e.code == 'weak-password') {
        setState(() {
          passError = '비밀번호는 최소 6자 이상이어야 합니다.';
          isEmailError = false;
          isPassError = true;
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          emailError = '이메일 형식이 올바르지 않습니다.';
          isEmailError = true;
          isPassError = false;
        });
      } else {
        print('회원가입 실패: $e');
      }
    }
  }

  void saveUserInfo(String uid, String? email, String? nickname) {
    firestore.collection('users').doc(uid).set({
      'email': email,
      'nickname': nickname,
      'profile_image':
          'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FrW7cz%2FbtshHOuDgVH%2Fh00XAmNk3TVl017uCnEKg0%2Fimg.png',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("회원가입"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        toolbarHeight: 60,
        bottomOpacity: 20,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 34,
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '이메일',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: '이메일을 입력하세요',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Color(0xffFF8F9A),
                            ),
                          ),
                          isDense: true,
                        ),
                      ),
                      Offstage(
                        offstage: isEmailError ? false : true,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              emailError,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '비밀번호',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _passwordController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: '비밀번호를 입력하세요',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Color(0xffFF8F9A),
                            ),
                          ),
                          isDense: true,
                        ),
                      ),
                      Offstage(
                        offstage: isPassError ? false : true,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              passError,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: signUpWithEmail,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xffffBABA),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: const Text(
                        '회원가입',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
