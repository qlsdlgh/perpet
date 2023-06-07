import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/IoT/IoT_dry_feed_reserve.dart';
import 'package:perpet/widgets/no_glow_scroll.dart';

class IoTDryFeedScreen extends StatefulWidget {
  const IoTDryFeedScreen({Key? key}) : super(key: key);

  @override
  State<IoTDryFeedScreen> createState() => _IoTDryFeedScreen();
}

class _IoTDryFeedScreen extends State<IoTDryFeedScreen> {
  final firestore = FirebaseFirestore.instance;
  final User _currentUser = FirebaseAuth.instance.currentUser!;

  int feedCounter = 1;
  List<Map<String, dynamic>>? _feedData;

  int SERVER_PORT = 8080;
  String SERVER_IP = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFeedData(_currentUser.uid, 'DRY_MEAL');
  }

  Future getFeedData(String uid, String feedType) async {
    final feedsCollection = FirebaseFirestore.instance.collection('feeds');
    final querySnapshot = await feedsCollection
        .where('reserve_user_id', isEqualTo: uid)
        .where('feed_type', isEqualTo: feedType)
        .get();

    List<Map<String, dynamic>> feedDataList = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> feedData = doc.data();
      feedDataList.add(feedData);
    }

    _feedData = feedDataList;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '건식 급여',
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
      body: _feedData == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xffffBABA),
              ),
            )
          : Column(
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
                                if (feedCounter != 10) {
                                  feedCounter++;
                                }
                              });
                            },
                            icon: feedCounter == 10
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
                            // 소켓 통신 코드
                            socket.writeln('DRY_MEAL');
                            socket.writeln(feedCounter); // int
                            socket.close();
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xffFFC46B)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
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
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DryFeedReserve())).then(
                                  (value) {
                                    getFeedData(_currentUser.uid, 'DRY_MEAL');
                                  },
                                );
                              },
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
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: _feedData!.length,
                                      itemBuilder: (context, index) {
                                        final data = _feedData![index];
                                        return ReservationList(
                                          time: data['reserve_time'],
                                          count: data['feed_count'].toString(),
                                          reserveId: data['reserve_id'],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 20,
                                      ),
                                    )
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

class ReservationList extends StatefulWidget {
  final String time, count, reserveId;

  const ReservationList({
    super.key,
    required this.time,
    required this.count,
    required this.reserveId,
  });

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  @override
  Widget build(BuildContext context) {
    void deletePost(String reserveId) async {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              '정말 취소하시겠습니까?',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('feeds')
                      .doc(reserveId)
                      .delete();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text('예약이 취소되었습니다.'),
                        actions: [
                          TextButton(
                            child: const Text(
                              'close',
                              style: TextStyle(color: Colors.black45),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const IoTDryFeedScreen()));
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  '예',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '아니오',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black26),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                widget.time,
                style: const TextStyle(fontSize: 35),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '건식 ${widget.count}회 급여',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              deletePost(widget.reserveId);
            },
            icon: const Icon(Icons.cancel_outlined),
          ),
        ],
      ),
    );
  }
}
