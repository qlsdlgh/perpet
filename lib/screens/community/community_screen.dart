import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perpet/screens/main_screen.dart';
import 'package:perpet/screens/community/posting_community.dart';

import '../../widgets/no_glow_scroll.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>>? _postData;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getPostData();
    fetchUserData();
  }

  Future getPostData() async {
    final collectionRef = FirebaseFirestore.instance.collection('posts');
    final querySnapshot = await collectionRef.get();

    _postData = await querySnapshotToList(querySnapshot);

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

  Future<void> fetchUserData() async {
    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();
    if (document.exists) {
      setState(() {
        _userData = document.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          heroTag: 'posting',
          backgroundColor: const Color(0xffffBABA),
          elevation: 0,
          onPressed: (_postData == null && _userData == null)
              ? () {}
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PostingScreen()),
                  ).then((value) {
                    getPostData();
                    setState(() {});
                  });
                },
          child: const Icon(Icons.edit),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const Text("커뮤니티"),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          toolbarHeight: 60,
          bottomOpacity: 20,
        ),
        body: (_postData == null && _userData == null)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: Color(0xffffBABA),
                        )),
                  ],
                ),
              )
            : ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: _postData != null
                            ? ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  final data = _postData![index];
                                  return Post(
                                      currentUser: _userData,
                                      postId: data['post_id'],
                                      title: data['post_title'],
                                      content: data['post_content'],
                                      time: data['post_time'],
                                      writerImage: data['writer_image'],
                                      writerName: data['post_writer']);
                                },
                                itemCount: _postData!.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 60,
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: Color(0xffffBABA)),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

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
  final _formKey = GlobalKey<FormState>();
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
    print(commentCount);

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
    final data = {
      'comment_content': content,
      'comment_image': widget.currentUser['profile_image'],
      'comment_writer': widget.currentUser['nickname']
    };

    await firestore
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add(data);
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
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(widget.writerImage),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.writerName,
                        style: const TextStyle(
                          fontSize: 15,
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
                        CommentCount(
                          count: commentCount!,
                        ),
                        ListView.separated(
                          reverse: true,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            final data = _commentData![index];
                            return Comment(
                                profileImage: data['comment_image'],
                                nickname: data['comment_writer'],
                                content: data['comment_content']);
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
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String profileImage, nickname, content;

  const Comment({
    super.key,
    required this.profileImage,
    required this.nickname,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(profileImage),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                nickname,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: Row(
              children: [
                Text(
                  content,
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
