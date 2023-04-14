import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'diary_calender_screen.dart';
import 'community_screen.dart';
import 'inputPet.dart';

//로그인 후 보이는 첫화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var petList = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text("Home"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        toolbarHeight: 60,
        bottomOpacity: 20,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "오늘은 반려동물에게 무슨 일이 있었나요?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ButtonTheme(
                          minWidth: 100.0,
                          height: 50.0,
                          child: ElevatedButton(
                              //다이어리 쓰러 가는 버튼
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.pink[100])),
                              child: const Text("다이어리 쓰러가기"),
                              onPressed: () {
                                //버튼 눌렀을 때 다이어리 쓰기 버튼으로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DiaryScreen()),
                                );
                              })),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const Text(
                        "동네 이웃들과 일상을 공유해요",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ButtonTheme(
                          minWidth: 100.0,
                          height: 50.0,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.pink[100])),
                              child: const Text("커뮤니티 바로가기"),
                              onPressed: () {
                                //커뮤니티 바로가기 버튼을 눌렀을 때 해당 화면으로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CommunityScreen()),
                                );
                              })),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                "나의 반려 동물",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  //차후엔 자기 동물 사진으로 바꿀 수 있게 하거나
                  //상표? 넣기
                  //이미 등록된 반려동물
                  for (int i = 0; i < petList.length; i++) petList[i],
                  //반려동물 추가하기 버튼
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pink[50],
                    ),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: InputPet(),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.plus,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
