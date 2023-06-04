import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perpet/widgets/no_glow_scroll.dart';

class IoTWetFeedScreen extends StatefulWidget {
  const IoTWetFeedScreen({Key? key}) : super(key: key);

  @override
  State<IoTWetFeedScreen> createState() => _IoTWetFeedScreen();
}

class _IoTWetFeedScreen extends State<IoTWetFeedScreen> {
  int feedCounter = 1;

  int SERVER_PORT = 8080;
  String SERVER_IP = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '습식 급여',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        bottomOpacity: 20,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded),
            iconSize: 34,
          )
        ],
      ),
      body: Column(
        children: [
          // 횟수 영역
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (feedCounter != 1) {
                            feedCounter--;
                          }
                        });
                      },
                      icon: feedCounter == 1
                          ? const Icon(
                              Icons.remove,
                              color: Colors.black26,
                            )
                          : const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        '$feedCounter',
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (feedCounter != 5) {
                            feedCounter++;
                          }
                        });
                      },
                      icon: feedCounter == 5
                          ? const Icon(
                              Icons.add,
                              color: Colors.black26,
                            )
                          : const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '회',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                // 급여 버튼
                TextButton(
                  onPressed: () {
                    Socket.connect(SERVER_IP, SERVER_PORT).then((socket) {
                      socket.writeln('습식');
                      socket.writeln(feedCounter); // int
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffFFC46B)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 40,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    '급여',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.alarm),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '예약 설정',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add_circle_rounded,
                          color: Color(0xffFFC46B),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: const SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              ReservationList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationList extends StatelessWidget {
  const ReservationList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black26),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '07:00',
            style: TextStyle(fontSize: 35),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '습식 1회 급여',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
