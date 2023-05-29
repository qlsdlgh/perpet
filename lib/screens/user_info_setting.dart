import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserInfoSetting extends StatefulWidget {
  const UserInfoSetting(
      {super.key, required this.currentUser, required this.isNav});

  final currentUser;
  final isNav;

  @override
  State<UserInfoSetting> createState() => _UserInfoSettingState();
}

class _UserInfoSettingState extends State<UserInfoSetting> {
  File? _imageFile;
  String? _imageUrl;
  bool isLoading = false;

  Future<void> _pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImageToFirebase() async {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 60, 40, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          isLoading
                              ? const CircularProgressIndicator()
                              : Stack(clipBehavior: Clip.antiAlias, children: [
                                  widget.currentUser['profile_image'] == null
                                      ? SvgPicture.asset(
                                          'assets/icons/circle-user-solid.svg',
                                          width: 200,
                                          height: 200,
                                          color: Colors.black.withOpacity(0.3))
                                      : CircleAvatar(
                                          radius: 100,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              '${widget.currentUser['profile_image']}'),
                                        ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        _pickImage(ImageSource.gallery);
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await _uploadImageToFirebase();
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            const Color(0xffFF8F9A),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.edit),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.currentUser['nickname'],
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '이메일',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFF8F9A)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.currentUser['email'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '비밀번호 변경',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFF8F9A)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        //controller: ,
                        //onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: '변경 비밀번호',
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
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        //controller: ,
                        //onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: '변경 비밀번호 확인',
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffFF8F9A)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 30,
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print(widget.currentUser['profile_image']);
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
                ],
              ),
            ),
            const SizedBox(
              height: 130,
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
                  onTap: () {},
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
