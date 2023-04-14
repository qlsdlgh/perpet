import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            child: Text("아이디"),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
          ),
          Container(
            child: Text("사진"),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
          ),
          Container(
            child: Text("아이콘들"),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
          ),
          Container(
            child: Text("좋아요 수"),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
          ),
          Container(
            child: Text("게시글"),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
          ),
          Container(
            child: Text("댓글"),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
          ),
        ],
      ),
    );
  }
}
