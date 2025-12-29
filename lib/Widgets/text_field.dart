import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon trailingIcon;
  final double fontSize;
  final double height;
  final double xPadding;
  final double yPadding;
  final double borderRadius;
  final Color textColor;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.trailingIcon,
    required this.fontSize,
    required this.height,
    this.textColor = Colors.white,
    this.xPadding = 10,
    this.yPadding = 10,
    this.borderRadius = 20
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: xPadding, vertical: yPadding),
      height: height,
        child: TextField(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.bottom,
          cursorHeight: 13,

          decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),
              alignLabelWithHint: true,
              suffixIcon: trailingIcon,
              hintStyle: TextStyle(
                  color: textColor, fontSize: fontSize - 0.5)
          ),
        )
    );
  }
}