import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String cover;
  final double iconSize;
  final double radius;

  const CustomIcon({super.key, required this.cover, required this.iconSize, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: iconSize,
        child: cover == ""
            ? Icon(
            Icons.videogame_asset_rounded)
            : Container(decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image.network(cover, fit: BoxFit.cover,)))
    );
  }
}