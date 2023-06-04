import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/no_glow_scroll.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  State<PostingScreen> createState() => _PostWriteScreen();
}

class _PostWriteScreen extends State<PostingScreen> {
  final firestore = FirebaseFirestore.instance;
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  final uuid = const Uuid();
  Map<String, dynamic>? _userData;
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserData();
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

  void savePosting(String title, String content) async {
    String postId = uuid.v4();
    final now = DateTime.now();
    String dataformat = DateFormat("MM-dd HH:mm").format(now);
    final userNameRef = firestore.collection('users').doc(_currentUser.uid);
    String? userName;

    await userNameRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;

      userName = data['nickname'];
    });

    await firestore.collection('posts').doc(postId).set({
      'post_id': postId,
      'post_time': dataformat,
      'post_title': title,
      'post_content': content,
      'post_writer': userName!,
      'writer_image': _userData!['profile_image'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("게시글 작성"),
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
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                savePosting(_title, _content);

                Fluttertoast.showToast(msg: '게시글 작성 성공');

                Future.delayed(const Duration(milliseconds: 200), () {
                  Navigator.pop(context);
                });
              }
            },
            icon: const Icon(Icons.check),
            iconSize: 34,
          )
        ],
      ),
      body: _userData == null
          ? Center(
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
          : ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '게시글 제목',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onSaved: (value) {
                                setState(() {
                                  _title = value as String;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '제목을 입력해주세요.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: '제목을 입력하세요',
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                isDense: true,
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffffBABA),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '게시글 내용',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onSaved: (value) {
                                setState(() {
                                  _content = value as String;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '내용을 입력해주세요.';
                                }
                                return null;
                              },
                              maxLines: 20,
                              decoration: InputDecoration(
                                hintText: '내용을 입력하세요',
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                contentPadding: const EdgeInsets.all(10),
                                isDense: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black38),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffffBABA),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
