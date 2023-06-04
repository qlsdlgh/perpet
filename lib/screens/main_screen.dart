import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/IoT/IoT_dry_feed_screen.dart';
import 'package:perpet/screens/IoT/IoT_wet_feed_screen.dart';
import 'package:perpet/screens/IoT/IoT_cam_screen.dart';
import 'package:perpet/screens/community/community_screen.dart';
import 'package:perpet/screens/map_screen.dart';
import 'package:perpet/screens/home_screen.dart';
import 'package:perpet/screens/setting/user_info_setting.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.current});

  final current;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget currentScreen = const HomeScreen();
  final PageStorageBucket bucket = PageStorageBucket();
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? _userData;

  int currentTab = 0;
  var alignment = Alignment.bottomLeft;

  @override
  void initState() {
    super.initState();

    if (widget.current == 1) {
      setState(() {
        currentTab = 1;
        currentScreen = const MapScreen();
      });
    } else if (widget.current == 2) {
      setState(() {
        currentTab = 2;
        currentScreen = const CommunityScreen();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();
    if (document.exists) {
      setState(() {
        _userData = document.data() as Map<String, dynamic>;
      });
    }
  }

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
                                  builder: (context) =>
                                      const IoTDryFeedScreen()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.pink[100]!),
                          ),
                          child: const Text(
                            "건식",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            //물 버튼 눌렀을 때 물 주는 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const IoTWetFeedScreen()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.pink[100]!),
                          ),
                          child: const Text(
                            "습식",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            //웹캠버튼을 눌렀을 때 웹캠 페이지로이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IoTCamScreen()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.white.withOpacity(0),
        splashColor: Colors.white.withOpacity(0),
        elevation: 0,
        child: Image.asset('assets/icons/iot_button.png'),
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
        height: 60,
        padding: const EdgeInsets.only(top: 10),
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: -5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              minWidth: 70,
              onPressed: () {
                setState(() {
                  currentScreen = const HomeScreen();
                  currentTab = 0;
                });
              },
              child: Column(
                children: [
                  currentTab == 0
                      ? const Icon(Icons.home)
                      : const Icon(Icons.home_outlined),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    '홈',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              minWidth: 77,
              onPressed: () {
                setState(() {
                  currentScreen = const MapScreen();
                  currentTab = 1;
                });
              },
              child: Column(
                children: [
                  currentTab == 1
                      ? const Icon(Icons.location_on_sharp)
                      : const Icon(Icons.location_on_outlined),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    '지도',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 60,
            ),
            MaterialButton(
              minWidth: 70,
              onPressed: () {
                setState(() {
                  currentScreen = const CommunityScreen();
                  currentTab = 2;
                });
              },
              child: Column(
                children: [
                  currentTab == 2
                      ? const Icon(Icons.description_rounded)
                      : const Icon(Icons.description_outlined),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    '커뮤니티',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              minWidth: 70,
              onPressed: () {
                setState(() {
                  currentScreen = const UserInfoSetting(
                    isNav: true,
                  );
                  currentTab = 3;
                });
              },
              child: Column(
                children: [
                  currentTab == 3
                      ? const Icon(Icons.person_3)
                      : const Icon(Icons.person_3_outlined),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    '마이페이지',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
