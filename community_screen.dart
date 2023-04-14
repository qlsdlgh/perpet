import 'package:flutter/material.dart';
import 'package:perpet/postcard.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        toolbarHeight: 60,
        bottomOpacity: 20,
        backgroundColor: Colors.pink[100],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
