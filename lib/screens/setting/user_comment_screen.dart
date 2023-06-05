import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/setting/user_comment_edit_screen.dart';

import '../../widgets/no_glow_scroll.dart';

class UserCommentScreen extends StatefulWidget {
  const UserCommentScreen({super.key});

  @override
  State<UserCommentScreen> createState() => _UserCommentScreenState();
}

class _UserCommentScreenState extends State<UserCommentScreen> {
  final firestore = FirebaseFirestore.instance;
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>>? _commentData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCommentData();
  }

  Future getCommentData() async {
    final postCollection = FirebaseFirestore.instance.collection('posts');
    final postSnapshot = await postCollection.get();

    List<Map<String, dynamic>> commentDataList = [];

    for (QueryDocumentSnapshot postDoc in postSnapshot.docs) {
      CollectionReference commentCollection =
          postDoc.reference.collection('comments');
      final commentSnapshot = await commentCollection
          .where('comment_writer_uid', isEqualTo: _currentUser.uid)
          .get();

      for (QueryDocumentSnapshot commentDoc in commentSnapshot.docs) {
        Map<String, dynamic> commentData =
            commentDoc.data() as Map<String, dynamic>;
        commentData['post_id'] = postDoc.id;
        commentDataList.add(commentData);
      }
    }

    _commentData = commentDataList;

    setState(() {});
  }

  Future<List<Map<String, dynamic>>> querySnapshotToList(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    final List<Map<String, dynamic>> dataList = [];

    for (var doc in snapshot.docs) {
      dataList.add(doc.data());
    }

    return dataList;
  }

  void deleteComment(String postId, String commentId) async {
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
                    .doc(postId)
                    .collection('comments');

                QuerySnapshot querySnapshot = await collectionRef
                    .where('comment_id', isEqualTo: commentId)
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
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("작성 댓글 관리"),
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
      ),
      body: _commentData == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xffffBABA)),
            )
          : ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _commentData!.length,
                        itemBuilder: (context, index) {
                          final data = _commentData![index];
                          return Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      data['comment_content'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserCommentEditScreen(
                                                        commentId:
                                                            data['comment_id'],
                                                        commentContent: data[
                                                            'comment_content'],
                                                        postId: data['post_id'],
                                                      ))).then((value) {
                                            getCommentData();
                                            setState(() {});
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xffffBABA)),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          '수정',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteComment(data['post_id'],
                                              data['comment_id']);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black38),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          '삭제',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

/*
Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator()),
                ],
              ),
            )
            */
