import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import '../petCard.dart';

class InputPet extends StatefulWidget {
  const InputPet({super.key});
  @override
  State<InputPet> createState() => _InputPet();
}

class _InputPet extends State<InputPet> {
  final isSelectedSex = <bool>[false, false];
  final isSelectedSpecies = <bool>[false, false];

  DateTime? _selectedTime;
  XFile? _pickedFile;
  var petname;
  var age;
  var sex;
  var pecies;
  var date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4;

    return SingleChildScrollView(
      child: Column(
        children: [
          const Text("반려동물"),
          TextField(
            //반려동물 이름
            onChanged: (text) {
              setState(() {
                petname = text;
              });
            },
            decoration: const InputDecoration(labelText: '이름'),
            keyboardType: TextInputType.name,
          ),

          TextField(
            //반려동물 나이
            onChanged: (text) {
              setState(() {
                age = text;
              });
            },
            decoration: const InputDecoration(labelText: '나이'),
            keyboardType: TextInputType.number,
          ),

          //성별고르는 버큰
          ToggleButtons(
            color: Colors.black.withOpacity(0.60),
            selectedColor: Colors.white,
            selectedBorderColor: Colors.pink[100],
            borderWidth: 2,
            fillColor: Colors.pink[50],
            splashColor: Colors.white,
            hoverColor: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            constraints: const BoxConstraints(minHeight: 36.0),
            isSelected: isSelectedSex,
            onPressed: (index) {
              setState(() {
                for (int i = 0; i < isSelectedSex.length; i++) {
                  isSelectedSex[i] = i == index;
                  sex = index;
                }
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('수컷'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('암컷'),
              ),
            ],
          ),

          // 종
          ToggleButtons(
            color: Colors.black.withOpacity(0.60),
            selectedColor: Colors.white,
            selectedBorderColor: Colors.pink[100],
            borderWidth: 2,
            fillColor: Colors.pink[50],
            splashColor: Colors.white,
            hoverColor: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            constraints: const BoxConstraints(minHeight: 36.0),
            isSelected: isSelectedSpecies,
            onPressed: (index) {
              setState(() {
                for (int i = 0; i < isSelectedSpecies.length; i++) {
                  isSelectedSpecies[i] = i == index;
                  pecies = index;
                }
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('강아지'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('고양이'),
              ),
            ],
          ),

          ElevatedButton(
            //출생 혹은 입양날짜 입력
            onPressed: () {
              Future<DateTime?> selectedDate = showDatePicker(
                context: context, // context 인수전달
                initialDate: DateTime.now(), // 초깃값
                firstDate: DateTime(1900), // 시작일 2000년 1월 1일
                lastDate: DateTime.now(), // 마지막일 2023년 1월 1일
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    // 따로 정의 하지 않으면 default 값이 설정 됨
                    data: ThemeData.light(), // 다크테마
                    child: child as Widget,
                  );
                },
              );
              selectedDate.then((dateTime) {
                setState(() {
                  _selectedTime = dateTime;
                  date = _selectedTime!;
                });
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              disabledForegroundColor: Colors.pink[100],
              disabledBackgroundColor: Colors.white,
            ),
            child: const Text('출생/입양 날짜'),
          ),
          Text(DateFormat('yyyy. MM. dd.').format(date)),
          const SizedBox(
            height: 20,
          ),
          if (_pickedFile == null)
            Container(
              constraints: BoxConstraints(
                minHeight: imageSize,
                minWidth: imageSize,
              ),
              child: GestureDetector(
                onTap: () {
                  _showBottomSheet();
                },
                child: Center(
                  child: Icon(
                    Icons.account_circle,
                    size: imageSize,
                  ),
                ),
              ),
            )
          else
            Center(
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.primary),
                  image: DecorationImage(
                      image: FileImage(File(_pickedFile!.path)),
                      fit: BoxFit.cover),
                ),
                child: GestureDetector(
                  onTap: () {
                    _showBottomSheet();
                  },
                ),
              ),
            ),

          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
              PetCard(petname, age, sex, pecies, date, _pickedFile);
            },
          ),
        ],
      ),
    );
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _getCameraImage(),
              child: const Text('사진찍기'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              child: const Text('라이브러리에서 불러오기'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }
}
