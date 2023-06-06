import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perpet/widgets/button_style.dart';
import 'package:uuid/uuid.dart';

class PetEditScreen extends StatefulWidget {
  final String petId, petType, petName, petAge, petWeight, petSex;

  const PetEditScreen({
    super.key,
    required this.petId,
    required this.petType,
    required this.petName,
    required this.petAge,
    required this.petWeight,
    required this.petSex,
  });

  @override
  State<PetEditScreen> createState() => _PetEditScreenState();
}

class _PetEditScreenState extends State<PetEditScreen> {
  final firestore = FirebaseFirestore.instance;
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _age;
  late String _weight;

  String _selectedPetType = '';
  bool _isDogSelect = false;
  bool _isCatSelect = false;

  final _valueList = ['여자아이', '남자아이'];
  String _selectedValue = '';

  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  final uuid = const Uuid();

  @override
  initState() {
    super.initState();
    setState(() {
      _selectedValue = _valueList[0];
    });
    if (widget.petType == 'dog') {
      _isDogSelect = true;
    } else {
      _isCatSelect = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void savePet(
      {required String uid,
      required String petType,
      required String petName,
      required String petAge,
      required String petWeight,
      required String petSex}) async {
    String petId = uuid.v4();

    await firestore
        .collection('users')
        .doc(uid)
        .collection('pets')
        .doc(petId)
        .update({
      'is_main': true,
      'petId': petId,
      'petImage': _imageUrl ??
          'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbRHwqW%2FbtshaszemDc%2FbPQFunfimkFbsCksNzcPqK%2Fimg.png',
      'petType': petType,
      'petName': petName,
      'petAge': petAge,
      'petWeight': petWeight,
      'petSex': petSex,
    });
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

    setState(() {
      _isLoading = true;
    });

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('pet_images').child(fileName);

      final uploadTask = firebaseStorageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});

      final imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (error) {
      print('Error uploading image to Firebase: $error');
    }

    setState(() {
      _isLoading = false;
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
        title: const Text("반려동물 정보 수정"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      child: _isDogSelect
                          ? Image.asset(
                              'assets/icons/dog_icon_select.png',
                              scale: 1,
                            )
                          : Image.asset(
                              'assets/icons/dog_icon.png',
                              scale: 1,
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
                              scale: 1,
                            )
                          : Image.asset(
                              'assets/icons/cat_icon.png',
                              scale: 1,
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
                      '반려동물 사진',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(clipBehavior: Clip.antiAlias, children: [
                      _isLoading == true
                          ? const CircularProgressIndicator(
                              color: Color(0xffffBABA))
                          : _imageUrl == null
                              ? Image.asset('assets/icons/circle-paw.png',
                                  width: 150,
                                  color: Colors.black.withOpacity(0.3))
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage('$_imageUrl'),
                                ),
                      _isLoading == true
                          ? const Spacer()
                          : Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xffffBABA),
                                child: IconButton(
                                  onPressed: () async {
                                    _pickImage(ImageSource.gallery);
                                    await _uploadImageToFirestore();
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ]),
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
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: widget.petName,
                      onSaved: (value) {
                        setState(() {
                          _name = value as String;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이름을 입력해주세요.';
                        }
                        return null;
                      },
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
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: widget.petAge,
                      onSaved: (value) {
                        setState(() {
                          _age = value as String;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '나이를 입력해주세요.';
                        }
                        return null;
                      },
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
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: widget.petWeight,
                      onSaved: (value) {
                        setState(() {
                          _weight = value as String;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '몸무게를 입력해주세요.';
                        }
                        return null;
                      },
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
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      savePet(
                        uid: _currentUser.uid,
                        petAge: _age,
                        petName: _name,
                        petSex: _selectedValue,
                        petType: _selectedPetType,
                        petWeight: _weight,
                      );

                      Fluttertoast.showToast(msg: '반려동물 등록 성공');

                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const CustomButton(
                    text: '등록',
                    bgColor: Color(0xffffBABA),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
