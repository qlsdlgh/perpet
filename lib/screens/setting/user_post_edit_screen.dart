import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/setting/user_post_screen.dart';

import '../../widgets/no_glow_scroll.dart';

class UserPostEditScreen extends StatefulWidget {
  final postId, postTitle, postContent;

  const UserPostEditScreen(
      {super.key,
      required this.postId,
      required this.postTitle,
      required this.postContent});

  @override
  State<UserPostEditScreen> createState() => _UserPostEditScreenState();
}

class _UserPostEditScreenState extends State<UserPostEditScreen> {
  final firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void editPosting(String title, String content) async {
    await firestore.collection('posts').doc(widget.postId).update({
      'post_title': title,
      'post_content': content,
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
        title: const Text("작성 글 수정"),
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

                editPosting(_title, _content);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text('게시글을 수정했습니다.'),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserPostScreen()));
                          },
                        )
                      ],
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.check),
            iconSize: 34,
          )
        ],
      ),
      body: ScrollConfiguration(
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
                        initialValue: widget.postTitle,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        decoration: const InputDecoration(
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
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
                        initialValue: widget.postContent,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38),
                          ),
                          focusedBorder: OutlineInputBorder(
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
