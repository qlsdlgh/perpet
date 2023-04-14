import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../waterCard.dart';

class IoTWaterScreen extends StatefulWidget {
  const IoTWaterScreen({Key? key}) : super(key: key);

  @override
  State<IoTWaterScreen> createState() => _IoTWaterScreen();
}

class _IoTWaterScreen extends State<IoTWaterScreen> {
  var waterList = <WaterCard>[const WaterCard(0), const WaterCard(1)];

  int currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text("Water"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        toolbarHeight: 60,
        bottomOpacity: 20,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                ),
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black.withOpacity(0.60),
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Text(
                  '물',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
              ),
              Row(
                //물 얼마나 줄지 횟수 정하는 부분
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        //-버튼을 누르면 작동하는 코드
                        //물 주는 횟수가 -가 되지 않도록, 0 이상일 때만 감소 가능
                        if (currentValue > 0) {
                          setState(() {
                            currentValue--;
                          });
                        }
                      },
                      child: Text(
                        "-",
                        style: TextStyle(fontSize: 60, color: Colors.pink[100]),
                      )),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Column(
                    //현재 부여할 예정인 물 양
                    children: [
                      Text(
                        currentValue.toString(),
                        style: const TextStyle(fontSize: 90),
                      ),
                      const Text(
                        //숫자 아래에 회 글자
                        "회",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            //회 글씨 굵게 하고싶으면 bold, 그냥은 normal
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  TextButton(
                      //+버튼
                      onPressed: () {
                        //+버튼 눌렀을 때 작동하는 코드
                        setState(() {
                          //물 양 증가
                          currentValue++;
                        });
                      },
                      child: Text(
                        "+",
                        style: TextStyle(fontSize: 50, color: Colors.pink[100]),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  //급여 버튼
                  onPressed: () {
                    //버튼을 눌렀을 때 작동하는 코드
                    if (currentValue == 0) {
                      //물 줄 횟수가 0이라면 횟수를 정하라는 팝업 알림 제공
                      showDialog(
                          context: context,
                          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text("물 급여 횟수를 정해주세요"),
                              insetPadding:
                                  const EdgeInsets.fromLTRB(0, 80, 0, 80),
                              actions: [
                                TextButton(
                                  child: const Text('확인'),
                                  onPressed: () {
                                    //확인 버튼을 눌렀을 때 팝업이 사라지는 버튼
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    } else {
                      //물 횟수가 0이 아니라면 물을 준 기록에 Water카드를 추가
                      //Water카드에는 현재 물을 얼마나 줄것인지에 대한 정보가 저장된다.
                      waterList.add(WaterCard(currentValue));
                    }
                  },
                  child: Text(
                    "급수",
                    style: TextStyle(fontSize: 15, color: Colors.pink[100]),
                  ),
                ),
              ),
              const Text(
                "* 1회 급여분량은 약 ---ml입니다.",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              /* 잘못..만들어진... 급수 기록지..
              //이거 실행 시키면 지금 물을 언제 얼마만큼 줬는지 출력 된다..

              Column(
                children: [
                  for (int i = 0; i < waterList.length; i++) waterList[i]
                ],
              ),
              */
            ],
          )),
    );
  }
}
