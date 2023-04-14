import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});
//게시글 보이는데 사용 될 카드
  // DB와 연공해서 해당 Container에 넣을 수 있도록 수정 해야함
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
            child: const Text("아이디"),
          ),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
            child: const Text("사진"),
          ),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
            child: const Text("아이콘들"),
          ),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
            child: const Text("좋아요 수"),
          ),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
            child: const Text("게시글"),
          ),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(),
            ),
            child: const Text("댓글"),
          ),
        ],
      ),
    );
  }
}
