import 'package:flutter/material.dart';

class Lista extends StatelessWidget
{
  final String title;
  final String lastMessages;

  const Lista({super.key, required this.title, required this.lastMessages});

  @override
  Widget build(BuildContext context)
  {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),),
      subtitle: Text(lastMessages, style: TextStyle(fontSize: 12),),
      tileColor: Colors.grey,
    );
  }
}