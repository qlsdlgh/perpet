import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/community/community_post.dart';
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
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
