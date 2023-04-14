import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetCard extends StatelessWidget {
  final String petname;
  final int age;
  final String sex;
  final String species;
  final DateTime birthday;
  final XFile? petPicture;

  //const PetCard(this.pet, this.species, this.sex, this.birthday, {super.key});
  const PetCard(this.petname, this.age, this.sex, this.species, this.birthday,
      this.petPicture,
      {super.key});
//말이 카드지, 그냥 사료 정보와 횟수 정보를 저장하는 영역
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink[50],
      ),
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 2, color: Theme.of(context).colorScheme.primary),
          image: DecorationImage(
              image: FileImage(File(petPicture!.path)), fit: BoxFit.cover),
        ),
        child: GestureDetector(
          onTap: () {},
        ),
      ),
    );
  }
}
