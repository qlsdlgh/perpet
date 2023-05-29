import 'package:flutter/material.dart';

class IoTFeedScreen extends StatefulWidget {
  const IoTFeedScreen({Key? key}) : super(key: key);

  @override
  State<IoTFeedScreen> createState() => _IoTFeedScreen();
}

class _IoTFeedScreen extends State<IoTFeedScreen> {
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
      body: const SingleChildScrollView(
          padding: EdgeInsets.all(40.0), child: Column()),
    );
  }
}
