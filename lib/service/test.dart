import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future test() async {
  try {
    kakao.User user = await kakao.UserApi.instance.me();
    print('사용자 정보 요청 성공'
        '\n회원번호: ${user.id}'
        '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
        '\n프로필사진: ${user.kakaoAccount?.profile?.profileImageUrl}'
        '\n이메일: ${user.kakaoAccount?.email}');
  } catch (error) {
    print('사용자 정보 요청 실패 $error');
  }
}
