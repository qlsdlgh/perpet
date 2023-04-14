import 'package:flutter/material.dart';
import 'diary_calender_screen.dart';
import 'community_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.pink[100])),
                              child: const Text("다이어리 쓰러가기"),
                              onPressed: () {
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommunityScreen()),
                                );
                              })),
                      const SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              "나의 반려 동물",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const Image(
              image: AssetImage('picture/고슴도치.jpg'), // 나중에 로고로 바꾸기
              width: 170,
              height: 190,
            ),
          ],
        ),
      ),
    );
  }
}
