import 'package:flutter/material.dart';

class QuickButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const QuickButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
      ),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(bgColor),
        foregroundColor: MaterialStateProperty.all(textColor),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(15.0)),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
