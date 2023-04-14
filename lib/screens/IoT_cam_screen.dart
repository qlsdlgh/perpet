import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IoTCamScreen extends StatefulWidget {
  const IoTCamScreen({Key? key}) : super(key: key);

  @override
  State<IoTCamScreen> createState() => _IoTCamScreen();
}

class _IoTCamScreen extends State<IoTCamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text("캠"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        toolbarHeight: 60,
        bottomOpacity: 20,
      ),
      body: Column(
        children: [
          const Padding(
            //여기에 캠 화면 들어가야함
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: SizedBox(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Image(
                  image: AssetImage('picture/고슴도치.jpg'), // 나중에 로고로 바꾸기
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ButtonBar(
              //화면 캡쳐, 녹화 버튼
              alignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      //캡쳐버튼 눌렀을 때 실행 될 코드
                    },
                    child: const Text("화면 캡쳐")),
                OutlinedButton(
                    onPressed: () {
                      //녹화버튼 눌렀을 떄 실행될 코드
                    },
                    child: const Text("화면 녹화")),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: ButtonBar(
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          //왼쪽회전 눌렀을 때 실행될 코드
                        },
                        child: const SizedBox(
                          height: 70,
                          width: 70,
                          child: Text("왼쪽회전"),
                        )),
                    OutlinedButton(
                        onPressed: () {
                          //마이크 버튼을 눌렀을 때 실행될 코드
                        },
                        child: const SizedBox(
                          height: 100,
                          width: 100,
                          child: Text("마이크"),
                        )),
                    OutlinedButton(
                        onPressed: () {
                          //오른쪽 회전 눌렀을 때 실행될 코드
                        },
                        child: const SizedBox(
                          height: 70,
                          width: 70,
                          child: Text("오른쪽회전"),
                        )),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
