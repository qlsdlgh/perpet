import 'package:flutter/material.dart';
import 'package:perpet/screens/sign_up_pet_screen.dart';

//회원가입 화면
//로그 인 후에는 앱 켤떄 안보이게 하기
class SignUpUserScreen extends StatefulWidget {
  const SignUpUserScreen({Key? key}) : super(key: key);

  @override
  State<SignUpUserScreen> createState() => _SignUpUserScreen();
}

class _SignUpUserScreen extends State<SignUpUserScreen> {
  final _valueList = [
    '동네(구)',
    '중구',
    '동구',
    '서구',
    '남구',
    '북구',
    '수성구',
    '달서구',
    '달성군',
  ];
  String? _selectValue = '동네(구)';

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
              const Text(
                "사용자",
              ),
              const TextField(
                //이름 입력하는 곳
                decoration: InputDecoration(labelText: '이름'),
                keyboardType: TextInputType.emailAddress,
              ),
              DropdownButton<String>(
                  //사는 지역 고르는 버튼
                  value: _selectValue,
                  items: _valueList
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectValue = value;
                    });
                  }),
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
                      child: const Text("다음"),
                      onPressed: () {
                        //다음 버튼을 눌렀을 때 실행될 코드
                        //동물 정보 입력하는 페이지로 넘어가기
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPetScreen()),
                        );
                      }))
            ],
          ),
        ));
  }
}
