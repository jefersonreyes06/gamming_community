import 'package:flutter/material.dart';

class Lista extends StatelessWidget
{
  //Key key;
  double padding;
  String title;

  Lista({super.key, required this.title, required this.padding});

  @override
  Widget build(BuildContext context)
  {
    // TODO: implement build
    return ListTile(
      title: Text(title),
      subtitle: Text("data"),
      style: ListTileStyle.list,
      tileColor: Colors.white30,
    );
  }
}