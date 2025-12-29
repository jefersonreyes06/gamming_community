import 'package:flutter/material.dart';

class CustomSearch extends StatefulWidget
{
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double height;
  final double widthTextField;
  final String title;
  final String hintText;
  final Icon trailingIcon;

  const CustomSearch({
    super.key,
    required this.backgroundColor, this.textColor = Colors.white,
    required this.title, required this.hintText, this.height = 35,
    required this.trailingIcon, this.fontSize = 12, this.widthTextField = 150
  });

  @override
  State<CustomSearch> createState() => CustomSearchState();
}

class CustomSearchState extends State<CustomSearch>
{
  @override
  Widget build (BuildContext context)
  {
    return Container(
      height: widget.height,
        color: widget.backgroundColor,
        padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 10),

        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(widget.title, style: TextStyle(fontSize: widget.fontSize, color: widget.textColor)),
              SizedBox(width: 20),

              Container(
                height: widget.height-4,
                width: widget.widthTextField,

                child: TextField(
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.bottom,
                  cursorHeight: 13,

                  decoration: InputDecoration(

                      hintText: widget.hintText,
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      suffixIcon: widget.trailingIcon,
                      hintStyle: TextStyle(color: widget.textColor, fontSize: widget.fontSize-0.5)
                  ),
                ),
              ),
            ]
        )
    );
  }
}