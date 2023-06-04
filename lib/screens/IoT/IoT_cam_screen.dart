import 'package:flutter/material.dart';
import 'package:perpet/widgets/no_glow_scroll.dart';

class IoTCamScreen extends StatefulWidget {
  const IoTCamScreen({Key? key}) : super(key: key);

  @override
  State<IoTCamScreen> createState() => _IoTCamScreen();
}

class _IoTCamScreen extends State<IoTCamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '웹캠 확인',
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
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                ),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.black,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'cam screen',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.black26,
                        child: Icon(
                          Icons.rotate_left_rounded,
                          color: Colors.black87,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black26,
                        child: Icon(
                          Icons.mic,
                          color: Colors.black87,
                          size: 60,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.black26,
                        child: Icon(
                          Icons.rotate_right_rounded,
                          color: Colors.black87,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
