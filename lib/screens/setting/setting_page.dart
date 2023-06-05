import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:perpet/screens/setting/user_comment_screen.dart';
import 'package:perpet/screens/setting/user_info_setting.dart';
import 'package:perpet/screens/setting/pet_info_screen.dart';
import 'package:perpet/screens/setting/user_post_screen.dart';

import '../../widgets/no_glow_scroll.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.currentUser});

  final currentUser;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("설정"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        toolbarHeight: 60,
        bottomOpacity: 20,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded),
            iconSize: 34,
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        width: 1.0,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          widget.currentUser['profile_image'] == null
                              ? SvgPicture.asset(
                                  'assets/icons/circle-user-solid.svg',
                                  width: 30,
                                  height: 30,
                                  color: Colors.black.withOpacity(0.3))
                              : CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(
                                      '${widget.currentUser['profile_image']}')),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.currentUser['nickname'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SettingCategory(text: '일반'),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserInfoSetting(
                            isNav: false,
                          ),
                        ),
                      );
                    },
                    child: const SettingItem(text: '내 정보 관리')),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PetInfo()));
                    },
                    child: const SettingItem(text: '내 반려동물 관리')),
                const SettingCategory(text: '커뮤니티'),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserPostScreen(),
                        ),
                      );
                    },
                    child: const SettingItem(text: '작성 글 관리')),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserCommentScreen(),
                        ),
                      );
                    },
                    child: const SettingItem(text: '작성 댓글 관리')),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          horizontal: BorderSide(
                    color: Colors.black.withOpacity(0.3),
                    width: 1.0,
                  ))),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: GestureDetector(
                    onTap: () {
                      logout();
                    },
                    child: Text(
                      '로그아웃',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      Fluttertoast.showToast(msg: '로그아웃');
    } catch (e) {
      print('로그아웃 중 오류 발생: $e');
    }
  }
}

class SettingCategory extends StatelessWidget {
  final String text;
  const SettingCategory({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xffffBABA),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String text;

  const SettingItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 18,
        ),
      ),
    );
  }
}
