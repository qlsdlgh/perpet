import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
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
                        SvgPicture.asset('assets/icons/circle-user-solid.svg',
                            width: 50,
                            height: 50,
                            color: Colors.black.withOpacity(0.3)),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'userName',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SettingCategory(text: '일반'),
              const SettingItem(text: '내 정보 관리'),
              const SettingItem(text: '내 반려동물 정보 관리'),
              const SettingCategory(text: '기기 관리'),
              const SettingItem(text: '웹캠 관리'),
              const SettingItem(text: '자동급식기 관리'),
              const SettingCategory(text: '커뮤니티'),
              const SettingItem(text: '작성 글 관리'),
              const SettingItem(text: '작성 댓글 관리'),
              const SizedBox(
                height: 100,
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
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          fontSize: 22,
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 22,
        ),
      ),
    );
  }
}
