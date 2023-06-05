import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perpet/screens/community/community_comment.dart';
import 'package:perpet/screens/main_screen.dart';
import 'package:uuid/uuid.dart';

class Post extends StatefulWidget {
  final currentUser;
  final String title, content, postId, time, writerImage, writerName;

  const Post({
    super.key,
    required this.currentUser,
    required this.title,
    required this.content,
    required this.postId,
    required this.time,
    required this.writerImage,
    required this.writerName,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final firestore = FirebaseFirestore.instance;
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final uuid = const Uuid();

  String? _comment;
  String? commentCount;
  List<Map<String, dynamic>>? _commentData;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    getCommentData();
  }

  Future getCommentData() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments');
    final querySnapshot = await collectionRef.get();
    _commentData = await querySnapshotToList(querySnapshot);

    final commentCountRef = await FirebaseFirestore.instance
        .collection('/posts/${widget.postId}/comments')
        .get();

    commentCount = commentCountRef.docs.length.toString();

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

  void saveComment(String? content) async {
    String commentId = uuid.v4();

    await firestore
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .set({
      'comment_id': commentId,
      'comment_content': content,
      'comment_image': widget.currentUser['profile_image'],
      'comment_writer': widget.currentUser['nickname'],
      'comment_writer_uid': _currentUser.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.currentUser == null && _commentData == null)
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                        color: Color(0xffffBABA))),
              ],
            ),
          )
        : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(widget.writerImage),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.writerName,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    widget.content,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // 댓글
              (_commentData == null)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              height: 100,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                  color: Color(0xffffBABA))),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        commentCount == null
                            ? const Spacer()
                            : CommentCount(
                                count: commentCount!,
                              ),
                        ListView.separated(
                          reverse: false,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            final data = _commentData![index];
                            return Comment(
                              commentId: data['comment_id'],
                              profileImage: data['comment_image'],
                              nickname: data['comment_writer'],
                              content: data['comment_content'],
                              postId: widget.postId,
                              writerUid: data['comment_writer_uid'],
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: _commentData!.length,
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              // 댓글 입력
              Container(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black26,
                ))),
                child: Row(
                  children: [
                    widget.currentUser['profile_image'] == null
                        ? SvgPicture.asset('assets/icons/circle-user-solid.svg',
                            width: 30, color: Colors.black.withOpacity(0.3))
                        : CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                '${widget.currentUser['profile_image']}'),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (value) {
                            setState(() {
                              _comment = value as String;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '댓글 내용을 입력해주세요.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '댓글을 입력하세요',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            isDense: true,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black45,
                              width: 1,
                            )),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffffBABA),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            saveComment(_comment);

                            Fluttertoast.showToast(msg: '댓글 작성 성공');

                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainScreen(
                                            current: 2,
                                          )),
                                  (route) => false);
                            });

                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.check))
                  ],
                ),
              )
            ],
          );
  }
}

class CommentCount extends StatelessWidget {
  final String count;

  const CommentCount({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.message_outlined,
            size: 25,
            color: Colors.black45,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            count,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
