import 'package:flutter/material.dart';

class Lista extends StatelessWidget
{
  //Key key;
  double padding;
  String title;
  String lastMessages = '0';

  Lista({super.key, required this.title, required this.lastMessages, required this.padding});

  @override
  Widget build(BuildContext context)
  {
    // TODO: implement build
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
      subtitle: Text(lastMessages, style: TextStyle(fontSize: 9),),
      style: ListTileStyle.list,
      tileColor: Colors.white24,
    );
  }
}