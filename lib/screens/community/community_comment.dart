import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/main_screen.dart';

class Comment extends StatefulWidget {
  final String commentId, profileImage, nickname, content, postId, writerUid;

  const Comment(
      {super.key,
      required this.commentId,
      required this.profileImage,
      required this.nickname,
      required this.content,
      required this.postId,
      required this.writerUid});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void deleteComment(String fieldValue) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            '정말 삭제하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                CollectionReference collectionRef = FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.postId)
                    .collection('comments');

                QuerySnapshot querySnapshot = await collectionRef
                    .where('comment_id', isEqualTo: fieldValue)
                    .get();

                for (var doc in querySnapshot.docs) {
                  doc.reference.delete();
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text('댓글이 삭제되었습니다.'),
                      actions: [
                        TextButton(
                          child: const Text(
                            'close',
                            style: TextStyle(color: Colors.black45),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen(
                                          current: 2,
                                        )),
                                (route) => false);
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

  @override
  Widget build(BuildContext context) {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    return Container(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(widget.profileImage),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.nickname,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              widget.writerUid == currentUser.uid
                  ? IconButton(
                      onPressed: () {
                        deleteComment(widget.commentId);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 18,
                      ),
                    )
                  : const Spacer()
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: Row(
              children: [
                Text(
                  widget.content,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
