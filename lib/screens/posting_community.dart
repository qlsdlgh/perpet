import 'package:flutter/material.dart';
import 'package:perpet/screens/diary_calender_screen.dart';

class PostWriteScreen extends StatefulWidget {
  const PostWriteScreen({super.key});

  @override
  State<PostWriteScreen> createState() => _PostWriteScreen();
}

class _PostWriteScreen extends State<PostWriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("게시글 작성"),
          backgroundColor: Colors.pink[100],
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
          bottomOpacity: 15,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Form(
                      child: TextFormField(
                        //게시글 쓰는 칸
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black26,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black26,
                            )),
                            hintText: "게시글 쓰는 칸"),
                        maxLines: 20,
                      ),
                    )
                  ])),
              OutlinedButton(
                //게시글 올리는 버튼
                onPressed: () {
                  //확인 버튼을 눌렀을 때 작동하는 코드
                  //확인 버튼을 누를 시 데이터가 저장되어야 하고,
                  //이전 화면으로 갈 수 있도록 해야함

                  Navigator.of(context).pop();
                },
                child: const Text('올리기'),
              )
            ],
          ),
        ));
  }
}
