import 'package:flutter/material.dart';
import 'package:perpet/postcard.dart';
import 'package:perpet/screens/posting_community.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
//커뮤니티 화면
  //제대로 작동하기 전이다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[100],
        splashColor: Colors.pink[50],
        child: const Icon(Icons.add),
        onPressed: () {
          //버튼 눌렀을 때 다이어리 쓰기 버튼으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostWriteScreen()),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Community'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        toolbarHeight: 60,
        bottomOpacity: 20,
        backgroundColor: Colors.pink[100],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                //시험용으로 넣어둔 카드
                //나중엔 포스팅 된 게시물 수 만큼 출력되도록 한다.
                //물 입력 화면에 주석으로 처리 된 코드 참고해서 만들기
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
