import 'package:flutter/material.dart';

//회원가입 화면
//로그 인 후에는 앱 켤떄 안보이게 하기
class SignUpPetScreen extends StatefulWidget {
  const SignUpPetScreen({Key? key}) : super(key: key);

  @override
  State<SignUpPetScreen> createState() => _SignUpPetScreen();
}

class _SignUpPetScreen extends State<SignUpPetScreen> {
  final isSelectedSex = <bool>[false, false],
      isSelectedSpecies = <bool>[false, false];

  DateTime? _selectedTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "회원가입",
          ),
          backgroundColor: Colors.pink[100],
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
          bottomOpacity: 15,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const Text("반려동물"),
              const TextField(
                decoration: InputDecoration(labelText: '이름'),
                keyboardType: TextInputType.name,
              ),

              const TextField(
                decoration: InputDecoration(labelText: '나이'),
                keyboardType: TextInputType.number,
              ),

              //성별
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
                    isSelectedSex[index] = !isSelectedSex[index];
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
                    isSelectedSpecies[index] = !isSelectedSpecies[index];
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
                onPressed: () {
                  Future<DateTime?> selectedDate = showDatePicker(
                    context: context, // context 인수전달
                    initialDate: DateTime.now(), // 초깃값
                    firstDate: DateTime(2000), // 시작일 2000년 1월 1일
                    lastDate: DateTime(2023), // 마지막일 2023년 1월 1일
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        // 따로 정의 하지 않으면 default 값이 설정 됨
                        data: ThemeData.dark(), // 다크테마
                        child: child as Widget,
                      );
                    },
                  );
                  selectedDate.then((dateTime) {
                    setState(() {
                      _selectedTime = dateTime;
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
              Text('$_selectedTime'),

              const SizedBox(
                height: 40.0,
              ),
              ButtonTheme(
                  minWidth: 100.0,
                  height: 50.0,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 14, color: Colors.white)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink[100])),
                      child: const Text("완료"),
                      onPressed: () {}))
            ],
          ),
        ));
  }
}
