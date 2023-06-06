import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perpet/screens/IoT_feed_screen.dart';
import 'package:perpet/screens/IoT_water_screen.dart';
import 'package:perpet/screens/community_screen.dart';
import 'package:perpet/screens/diary_calender_screen.dart';
import 'package:perpet/screens/myPage_screen.dart';
import 'package:perpet/screens/home_screen.dart';
import 'package:perpet/screens/login_screen.dart';
import 'package:perpet/screens/sign_up_pet_screen.dart';
import 'package:perpet/screens/sign_up_user_screen.dart';

import 'IoT_cam_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void floatButtonBar() {
    //가운데 동그랗게 떠있는 버튼
    //사료, 물, 웹캠 버튼
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 0, 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            //사료 버튼 눌렀을 때 사료 주는 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IoTFeedScreen()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.pink[100]!),
                          ),
                          child: const Text(
                            "사료",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            //물 버튼 눌렀을 때 물 주는 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IoTWaterScreen()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.pink[100]!),
                          ),
                          child: const Text(
                            "물",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            //웹캠버튼을 눌렀을 때 웹캠 페이지로이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IoTCamScreen()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.pink[100]!),
                          ),
                          child: const Text(
                            "웹캠",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  int currentTab = 0;

  final Set<Widget> screens = {
    const LoginScreen(),
    const SignUpUserScreen(),
    const SignUpPetScreen(),
    //const WriteScreen(),
    const HomeScreen(),
    const DiaryScreen(),
    const IoTFeedScreen(),
    const IoTWaterScreen(),
    IoTCamScreen(),
    const CommunityScreen(),
    const myPageScreen(),
  };

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  var alignment = Alignment.bottomLeft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[100],
        splashColor: Colors.pink[50],
        child: const Icon(Icons.ac_unit_outlined),
        onPressed: () {
          setState(() {
            alignment = alignment == Alignment.bottomLeft
                ? Alignment.topRight
                : Alignment.bottomLeft;
          });

          floatButtonBar();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //플로팅 버튼을 제외한 바텀네비게이션바
        color: Colors.pink[100],
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //padding하나가 하나의 버튼
                  Padding(
                    //버튼 사이 간격 조절
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      minWidth: 60,
                      onPressed: () {
                        //버튼 눌렀을 때 작동하는 코드
                        setState(() {
                          currentScreen = const HomeScreen();
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.home,
                            color:
                                currentTab == 0 ? Colors.white : Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      minWidth: 60,
                      onPressed: () {
                        //버튼 눌렀을 때 작동하는 코드
                        setState(() {
                          currentScreen = const DiaryScreen();
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.book,
                            color:
                                currentTab == 1 ? Colors.white : Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 30)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      minWidth: 60,
                      onPressed: () {
                        //버튼 눌렀을 때 작동하는 코드
                        setState(() {
                          currentScreen = const CommunityScreen();
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.comment,
                            color:
                                currentTab == 2 ? Colors.white : Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      minWidth: 60,
                      onPressed: () {
                        //버튼 눌렀을 때 작동하는 코드
                        setState(() {
                          currentScreen = const myPageScreen();
                          currentTab = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.user,
                            color:
                                currentTab == 3 ? Colors.white : Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
