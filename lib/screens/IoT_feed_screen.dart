import 'package:flutter/material.dart';

import '../feedCard.dart';

class IoTFeedScreen extends StatefulWidget {
  const IoTFeedScreen({Key? key}) : super(key: key);

  @override
  State<IoTFeedScreen> createState() => _IoTFeedScreen();
}

class _IoTFeedScreen extends State<IoTFeedScreen> {
  var feedList = <FeedCard>[
    const FeedCard("예시0 ", 0),
    const FeedCard("예시1 ", 1)
  ];

  final isSelectedFeed = <bool>[false, false]; //건식 습식 고를때 사용
  int currentValue = 0; //급여할 횟수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text("Feed"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        toolbarHeight: 60,
        bottomOpacity: 20,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              ToggleButtons(
                //건식과 습식 중 하나 고르기
                color: Colors.black.withOpacity(0.60),
                selectedColor: Colors.white,
                selectedBorderColor: Colors.pink[100],
                borderWidth: 2,
                fillColor: Colors.pink[50],
                splashColor: Colors.white,
                hoverColor: Colors.white,
                borderRadius: BorderRadius.circular(4.0),
                constraints: const BoxConstraints(minHeight: 36.0),
                isSelected: isSelectedFeed,
                onPressed: (index) {
                  //건식과 습식 중 하나만 선택할 수 있게 하기
                  setState(() {
                    for (int i = 0; i < isSelectedFeed.length; i++) {
                      isSelectedFeed[i] = i == index;
                    }
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                    ),
                    child: Text(
                      '건식',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                    ),
                    child: Text(
                      '습식',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //급여 횟수 조절하는 부분
                  TextButton(
                      //-버튼
                      onPressed: () {
                        //눌렀을 때 작동하는 코드
                        //음수가 되지 않도록, 0보다 클때만 감소 할 수 있게 함
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
                    children: [
                      Text(
                        //현재얼마나 줄 예정인지 보여줌
                        currentValue.toString(),
                        style: const TextStyle(fontSize: 90),
                      ),
                      const Text(
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
                        //+눌렀을 떄 카운트를 증가시킴
                        setState(() {
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
                  //확인버튼
                  onPressed: () {
                    //확인 버튼을 눌렀을 때 실행될 코드
                    //건식과 습식 중 하나를 고르지 않았을 시 고르라는 경고 문구가 뜸
                    if (isSelectedFeed[0] == false &&
                        isSelectedFeed[1] == false) {
                      showDialog(
                          context: context,
                          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text("사료의 종류를 선택해 주세요"),
                              insetPadding:
                                  const EdgeInsets.fromLTRB(0, 80, 0, 80),
                              actions: [
                                TextButton(
                                  child: const Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    } else if (currentValue == 0) {
                      //건식 습식은 골랐으나 횟수를 정하지 않았을 시, 횟수를 지정하라는 문구가 뜸
                      showDialog(
                          context: context,
                          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text("사료 급여 횟수를 정해주세요"),
                              insetPadding:
                                  const EdgeInsets.fromLTRB(0, 80, 0, 80),
                              actions: [
                                TextButton(
                                  child: const Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    } else {
                      //위의 건식과 습식 정보를 구분하여 현재 횟수와 사료 종류를 Feed카드에 넣어서
                      //리스트에 보관
                      if (isSelectedFeed[0] == false) {
                        feedList.add(FeedCard("습식", currentValue));
                      } else {
                        feedList.add(FeedCard("건식", currentValue));
                      }
                    }
                  },
                  child: Text(
                    "급여",
                    style: TextStyle(fontSize: 15, color: Colors.pink[100]),
                  ),
                ),
              ),
              const Text(
                "* 1회 급여분량은 약 ---g입니다.",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              /* 잘못.. 만들어진.. 급여기록지..
              Column(
                children: [
                  for (int i = 0; i < feedList.length; i++) feedList[i]
                ],
              ),
               */
            ],
          )),
    );
  }
}
