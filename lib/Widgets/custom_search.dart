import 'package:flutter/material.dart';

class CustomSearch extends StatefulWidget {
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
    required this.backgroundColor,
    this.textColor = Colors.white,
    required this.title,
    required this.hintText,
    this.height = 35,
    required this.trailingIcon,
    this.fontSize = 12,
    this.widthTextField = 150,
  });

  @override
  State<CustomSearch> createState() => CustomSearchState();
}

class CustomSearchState extends State<CustomSearch> {
  @override
  Widget build(BuildContext context) {
    final bool hasTitle = widget.title.trim().isNotEmpty;

    return Container(
      height: widget.height,
      color: widget.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          if (hasTitle)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.textColor,
                ),
              ),
            ),

          Expanded(
            flex: hasTitle ? 0 : 1,
            child: Container(
              height: widget.height - 4,
              width: hasTitle ? widget.widthTextField : null,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),

              child: TextField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                cursorHeight: 13,

                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: const OutlineInputBorder(),
                  suffixIcon: widget.trailingIcon,
                  hintStyle: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize - 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
