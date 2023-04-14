import 'package:flutter/material.dart';
import 'package:perpet/screens/diary_calender_screen.dart';

class WriteScreen extends StatefulWidget {
  final String data;

  const WriteScreen(this.data);

  @override
  State<WriteScreen> createState() => _WriteScreen();
}

class _WriteScreen extends State<WriteScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //앱 바에 캘린더로부터 전달받은 날짜 출력하기
        appBar: AppBar(
          title: Text(widget.data),
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
              Container(),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black26,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black26,
                            )),
                            hintText: "일기 입력란"),
                        maxLines: 20,
                      ),
                    )
                  ])),
              OutlinedButton(
                onPressed: () {
                  final formKeyState = _formKey.currentState!;
                  if (formKeyState.validate()) {
                    formKeyState.save();
                  }
                },
                child: const Text('확인'),
              )
            ],
          ),
        ));
  }
}
