import 'package:flutter/material.dart';

class WaterCard extends StatelessWidget {
  final int count;

  const WaterCard(this.count, {super.key});

  //말이 카드지, 그냥 물 얼마나 줬는지 저장하는 칸
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                  blurStyle: BlurStyle.solid)
            ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(children: [
                Text(
                  " $count회 급여",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
