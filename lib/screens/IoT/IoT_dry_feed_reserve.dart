import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/no_glow_scroll.dart';

class DryFeedReserve extends StatefulWidget {
  const DryFeedReserve({super.key});

  @override
  State<DryFeedReserve> createState() => _DryFeedReserveState();
}

class _DryFeedReserveState extends State<DryFeedReserve> {
  final firestore = FirebaseFirestore.instance;
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  final uuid = const Uuid();

  int feedCounter = 1;
  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void reserveFeed(DateTime time, int count) async {
    String reserveId = uuid.v4();
    String dateFormat = DateFormat("HH:mm").format(time);

    await firestore.collection('feeds').doc(reserveId).set({
      'reserve_id': reserveId,
      'reserve_time': dateFormat,
      'reserve_user_id': _currentUser.uid,
      'feed_count': count,
      'feed_type': 'DRY_MEAL',
    });

    // 예약 코드 여기 작성
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("급여 예약"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        toolbarHeight: 60,
        bottomOpacity: 20,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 34,
        ),
        actions: [
          IconButton(
            onPressed: () {
              reserveFeed(_dateTime!, feedCounter);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text('예약되었습니다.'),
                    actions: [
                      TextButton(
                        child: const Text(
                          'close',
                          style: TextStyle(color: Colors.black45),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.check),
            iconSize: 34,
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
            child: Column(
              children: [
                Column(
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
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                TimePickerSpinner(
                  is24HourMode: false,
                  spacing: 30,
                  normalTextStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.black38,
                  ),
                  highlightedTextStyle: const TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  ),
                  onTimeChange: (time) {
                    _dateTime = time;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
