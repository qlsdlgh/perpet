import 'package:flutter/material.dart';
import 'package:perpet/widgets/button_style.dart';

class SignUpPet extends StatelessWidget {
  const SignUpPet({super.key});

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
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '대표 반려동물 정보',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SelectSpecies(),
                    SizedBox(
                      height: 30,
                    ),
                    SignUpInput(label: '이름', hint: '반려동물 이름'),
                    SizedBox(
                      height: 30,
                    ),
                    SignUpInput(label: '나이', hint: '반려동물 나이'),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '성별',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Dropdown(),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home');
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
            const CustomButton(
              text: '건너뛰기',
              bgColor: Colors.white,
              textColor: Color(0xffffBABA),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpInput extends StatefulWidget {
  final String label, hint;

  const SignUpInput({
    super.key,
    required this.label,
    required this.hint,
  });

  @override
  State<SignUpInput> createState() => _SignUpInputState();
}

class _SignUpInputState extends State<SignUpInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          onSubmitted: (value) {},
          onChanged: (value) {},
          decoration: InputDecoration(
            hintText: widget.hint,
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
    );
  }
}

class SelectSpecies extends StatefulWidget {
  const SelectSpecies({super.key});

  @override
  State<SelectSpecies> createState() => _SelectSpeciesState();
}

class _SelectSpeciesState extends State<SelectSpecies> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: Image.asset(
            'assets/icons/dog_icon.png',
            scale: 0.9,
          ),
          onTap: () {},
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          child: Image.asset(
            'assets/icons/cat_icon.png',
            scale: 0.9,
          ),
          onTap: () {},
        )
      ],
    );
  }
}

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  final _valueList = ['여자아이', '남자아이'];
  String _selectedValue = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedValue = _valueList[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
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
    );
  }
}
