import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/setting/user_comment_screen.dart';

import '../../widgets/no_glow_scroll.dart';

class UserCommentEditScreen extends StatefulWidget {
  final postId, commentId, commentContent;

  const UserCommentEditScreen(
      {super.key,
      required this.postId,
      required this.commentId,
      required this.commentContent});

  @override
  State<UserCommentEditScreen> createState() => _UserCommentEditScreenState();
}

class _UserCommentEditScreenState extends State<UserCommentEditScreen> {
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

  void editComment(String content) async {
    await firestore
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(widget.commentId)
        .update({
      'comment_content': content,
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
        title: const Text("작성 댓글 수정"),
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

                editComment(_content);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text('댓글을 수정했습니다.'),
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
                                        const UserCommentScreen()));
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
                        '댓글 내용',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: widget.commentContent,
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
                        maxLines: 5,
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
