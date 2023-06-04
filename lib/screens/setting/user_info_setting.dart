import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:perpet/screens/main_screen.dart';

import '../../widgets/no_glow_scroll.dart';

class UserInfoSetting extends StatefulWidget {
  const UserInfoSetting({super.key, required this.isNav});
  final isNav;

  @override
  State<UserInfoSetting> createState() => _UserInfoSettingState();
}

class _UserInfoSettingState extends State<UserInfoSetting> {
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? _userData;
  File? _imageFile;
  String? _imageUrl;
  bool isLoading = false;
  bool isLoadingPassWord = false;

  final _formKey = GlobalKey<FormState>();
  late String _passWord;
  late String _passWordCheck;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserData();
  }

  void _showDialog(String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(content),
          actions: [
            TextButton(
                child: const Text(
                  'close',
                  style: TextStyle(color: Colors.black45),
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  void changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: user.email!,
            password: newPassword,
          ),
        );

        setState(() {
          isLoadingPassWord = true;
        });

        await user.updatePassword(newPassword);

        _showDialog('비밀번호가 변경되었습니다.');

        setState(() {
          isLoadingPassWord = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          _showDialog('기존 비밀번호입니다.');
        } else if (_passWord != _passWordCheck) {
          _showDialog('확인 비밀번호가 일치하지 않습니다.');
        } else if (e.code == 'weak-password') {
          _showDialog('비밀번호는 최소 6자 이상이어야 합니다.');
        } else {
          _showDialog('Error uploading image to Firebase: $e');
        }
      }
    } else {
      Fluttertoast.showToast(msg: '사용자 인증이 필요합니다');
    }
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

  Future<void> _pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImageToFirestore() async {
    if (_imageFile == null) return;

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName);

      final uploadTask = firebaseStorageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});

      final imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });

      final userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profile_image': imageUrl});
    } catch (error) {
      print('Error uploading image to Firebase: $error');
    }

    Fluttertoast.showToast(msg: '프로필 사진 변경 완료');

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const MainScreen(
                    current: 3,
                  )),
          (route) => false);
    });

    setState(() {});
  }

  void withdrawal() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              '정말 탈퇴하시겠습니까?',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.currentUser?.unlink('password');
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(_currentUser.uid)
                        .delete();
                    _showDialog('회원 탈퇴가 완료되었습니다.');
                    Future.delayed(const Duration(milliseconds: 400), () {
                      Navigator.popAndPushNamed(context, '/login');
                    });
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case "no-such-provider":
                        Fluttertoast.showToast(
                            msg:
                                "The user isn't linked to the provider or the provider "
                                "doesn't exist.");
                        break;
                      default:
                        Fluttertoast.showToast(msg: "Unkown error.");
                    }
                  }
                },
                child: const Text(
                  '예',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '아니오',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        bottomOpacity: 20,
        actions: widget.isNav
            ? []
            : [
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
          child: _userData == null
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xffffBABA)),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  isLoading
                                      ? const CircularProgressIndicator(
                                          color: Color(0xffffBABA),
                                        )
                                      : Stack(
                                          clipBehavior: Clip.antiAlias,
                                          children: [
                                              _userData!['profile_image'] ==
                                                      null
                                                  ? SvgPicture.asset(
                                                      'assets/icons/circle-user-solid.svg',
                                                      width: 200,
                                                      height: 200,
                                                      color: Colors.black
                                                          .withOpacity(0.3))
                                                  : CircleAvatar(
                                                      radius: 80,
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage: NetworkImage(
                                                          '${_userData!['profile_image']}'),
                                                    ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      const Color(0xffffBABA),
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      _pickImage(
                                                          ImageSource.gallery);
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      await _uploadImageToFirestore();
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    _userData!['nickname'],
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                                '이메일',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffBABA)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _userData!['email'],
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          isLoadingPassWord
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Color(0xffffBABA),
                                ))
                              : Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '비밀번호 변경',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffBABA)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        keyboardType: TextInputType.text,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onSaved: (value) {
                                          setState(() {
                                            _passWord = value as String;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '비밀번호를 입력해주세요.';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: '변경 비밀번호',
                                          hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Color(0xffffBABA),
                                            ),
                                          ),
                                          isDense: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        keyboardType: TextInputType.text,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        onSaved: (value) {
                                          setState(() {
                                            _passWordCheck = value as String;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '비밀번호를 입력해주세요.';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: '변경 비밀번호 확인',
                                          hintStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: Color(0xffffBABA),
                                            ),
                                          ),
                                          isDense: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xffffBABA)),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              padding:
                                                  MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 30,
                                                ),
                                              ),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();

                                                  changePassword(_passWord);
                                                }
                                              },
                                              child: const Text(
                                                '변경하기',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.symmetric(
                                horizontal: BorderSide(
                          color: Colors.black.withOpacity(0.3),
                          width: 1.0,
                        ))),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: GestureDetector(
                          onTap: () {
                            withdrawal();
                          },
                          child: Text(
                            '회원탈퇴',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 20,
                            ),
                          ),
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
