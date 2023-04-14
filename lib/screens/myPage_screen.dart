import 'package:flutter/material.dart';
import 'package:perpet/postcard.dart';

class myPageScreen extends StatefulWidget {
  const myPageScreen({Key? key}) : super(key: key);

  @override
  State<myPageScreen> createState() => _myPageScreen();
}

class _myPageScreen extends State<myPageScreen> {
  var option = [
    "내 정보 관리",
    "내 반려동물 정보 관리",
    "웹캠 관리",
    "자동 급식기 관리",
    "작성 글 관리",
    "작성 댓글 관리",
    "로그아웃"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text("Option"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        toolbarHeight: 60,
        bottomOpacity: 30,
      ),
      body: ListView.separated(
        //옵션 리스트에 있는 것들을 하나씩 버튼으로 나열
        itemCount: option.length,
        itemBuilder: (BuildContext ctx, int idx) {
          return TextButton(
            onPressed: () {
              //눌렀을 때 작동할 코드 입력
              //나중에 이동할 페이지도 option처럼 리스트로 입력할 예정
            },
            child: Text(
              option[idx],
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
        separatorBuilder: (BuildContext ctx, int idx) {
          return const Divider(
            height: 0,
            thickness: 1,
          );
        },
      ),
    );
  }
}
