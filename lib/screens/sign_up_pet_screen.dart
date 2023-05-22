import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpet/widgets/button_style.dart';

class SignUpPet extends StatefulWidget {
  const SignUpPet({super.key, required this.currentUser});

  final currentUser;

  @override
  State<SignUpPet> createState() => _SignUpPetState();
}

class _SignUpPetState extends State<SignUpPet> {
  final firestore = FirebaseFirestore.instance;

  void saveUserInfo(
      {required String uid,
      required String email,
      required String nickname,
      required String petType,
      required String petName,
      required String petAge,
      required String petSex}) async {
    await firestore.collection('users').doc(uid).set({
      'nickname': nickname,
    });

    await firestore
        .collection('users')
        .doc(uid)
        .collection('pets')
        .doc('$petName$uid')
        .set({
      'is_main': true,
      'petType': petType,
      'petName': petName,
      'petAge': petAge,
      'petSex': petSex,
    });
  }

  bool isNicknameError = false, isPassError = false;
  String nicknameError = '', passError = '';

  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petAgeController = TextEditingController();

  String _selectedPetType = '';
  bool _isDogSelect = false;
  bool _isCatSelect = false;

  final _valueList = ['여자아이', '남자아이'];
  String _selectedValue = '';

  @override
  initState() {
    super.initState();
    setState(() {
      _selectedValue = _valueList[0];
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
        title: const Text("추가 정보 입력"),
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
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '유저 정보',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '닉네임',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _nickNameController,
                          decoration: InputDecoration(
                            hintText: '사용자 닉네임',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Color(0xffFF8F9A),
                              ),
                            ),
                            isDense: true,
                          ),
                        ),
                        Offstage(
                          offstage: isNicknameError ? false : true,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                nicknameError,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      '대표 반려동물 정보',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: _isDogSelect
                              ? Image.asset(
                                  'assets/icons/dog_icon_select.png',
                                  scale: 0.9,
                                )
                              : Image.asset(
                                  'assets/icons/dog_icon.png',
                                  scale: 0.9,
                                ),
                          onTap: () {
                            setState(() {
                              _selectedPetType = 'dog';
                              if (_isCatSelect == true) {
                                _isCatSelect = false;
                              }
                              _isDogSelect = true;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: _isCatSelect
                              ? Image.asset(
                                  'assets/icons/cat_icon_select.png',
                                  scale: 0.9,
                                )
                              : Image.asset(
                                  'assets/icons/cat_icon.png',
                                  scale: 0.9,
                                ),
                          onTap: () {
                            setState(() {
                              _selectedPetType = 'cat';
                              if (_isDogSelect == true) {
                                _isDogSelect = false;
                              }
                              _isCatSelect = true;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '반려동물 이름',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _petNameController,
                          decoration: InputDecoration(
                            hintText: '반려동물 이름',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Color(0xffFF8F9A),
                              ),
                            ),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '반려동물 나이',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _petAgeController,
                          decoration: InputDecoration(
                            hintText: '반려동물 나이',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Color(0xffFF8F9A),
                              ),
                            ),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      '성별',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButton(
                      value: _selectedValue,
                      items: _valueList
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      },
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_nickNameController.text == '') {
                  setState(() {
                    isNicknameError = true;
                    nicknameError = '';
                  });
                } else {
                  saveUserInfo(
                    uid: widget.currentUser.uid,
                    email: widget.currentUser.email,
                    nickname: _nickNameController.text,
                    petType: _selectedPetType,
                    petName: _petNameController.text,
                    petAge: _petAgeController.text,
                    petSex: _selectedValue,
                  );
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/main', (route) => false);
                }
              },
              child: const CustomButton(
                text: '회원가입',
                bgColor: Color(0xffffBABA),
                textColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              },
              child: const CustomButton(
                text: '건너뛰기',
                bgColor: Colors.white,
                textColor: Color(0xffffBABA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
