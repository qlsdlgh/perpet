import 'package:flutter/material.dart';

class IoTWaterScreen extends StatefulWidget {
  const IoTWaterScreen({Key? key}) : super(key: key);

  @override
  State<IoTWaterScreen> createState() => _IoTWaterScreen();
}

class _IoTWaterScreen extends State<IoTWaterScreen> {
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
      body: const SingleChildScrollView(
          padding: EdgeInsets.all(40.0), child: Column()),
    );
  }
}
