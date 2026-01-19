import 'package:flutter/material.dart';

class CustomTextInteractive extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final double fontSize;
  final double width;
  final double height;
  final double fontWeight;
  final bool isCenter;
  void Function() onTap;

  CustomTextInteractive({super.key, required this.borderColor, required this.isCenter, required this.text, required this.color, required this.fontSize, required this.fontWeight, required this.onTap, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: color),
            ),
            Container(
              height: height,
              width: width,
              color: borderColor,
            ),
          ],
        ),
      );
  }
}