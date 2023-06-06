import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpet/widgets/button_style.dart';
import 'package:perpet/widgets/no_glow_scroll.dart';
import 'package:uuid/uuid.dart';

class SignUpPet extends StatefulWidget {
  const SignUpPet({super.key, required this.currentUser});

  final currentUser;

  @override
  State<SignUpPet> createState() => _SignUpPetState();
}

class _SignUpPetState extends State<SignUpPet> {
  final firestore = FirebaseFirestore.instance;
  final uuid = const Uuid();

  void saveUserInfo(
      {required String uid,
      required String email,
      required String nickname,
      required String petType,
      required String petName,
      required String petAge,
      required String petWeight,
      required String petSex}) async {
    String petId = uuid.v4();
    await firestore.collection('users').doc(uid).update({
      'nickname': nickname,
      'email': widget.currentUser.email,
    });

    await firestore.collection('users').doc(uid).collection('pets').add({
      'is_main': true,
      'petUserUid': uid,
      'petId': petId,
      'petImage':
          'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbRHwqW%2FbtshaszemDc%2FbPQFunfimkFbsCksNzcPqK%2Fimg.png',
      'petType': petType,
      'petName': petName,
      'petAge': petAge,
      'petWeight': petWeight,
      'petSex': petSex,
    });
  }

  bool isNicknameError = false, isPassError = false;
  String nicknameError = '', passError = '';

  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petAgeController = TextEditingController();
  final TextEditingController _petWeightController = TextEditingController();

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
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '유저 정보',
                        style: TextStyle(
                          fontSize: 20,
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
                              fontSize: 18,
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
                          fontSize: 20,
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
                              fontSize: 18,
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
                              fontSize: 18,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '반려동물 몸무게',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _petWeightController,
                            decoration: InputDecoration(
                              hintText: '반려동물 몸무게',
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
                          fontSize: 18,
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
            ),
            const SizedBox(
              height: 5,
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
                    petWeight: _petWeightController.text,
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
                    context, '/main', (route) => false);
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
