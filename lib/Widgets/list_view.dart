import 'package:flutter/material.dart';

class Lista extends StatelessWidget
{
  String title;
  String lastMessages = '0';

  Lista({super.key, required this.title, required this.lastMessages});

  @override
  Widget build(BuildContext context)
  {
    // TODO: implement build
    return ListTile(
      /*leading: CircleAvatar(
          child: FirebaseAuth.instance.currentUser!.photoURL!.isEmpty == true ? Icon(Icons.person) : Icon(Icons.person)),//Image.network(FirebaseAuth.instance.currentUser!.photoURL ?? "")
*/
      title: Text(title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),),
      subtitle: Text(lastMessages, style: TextStyle(fontSize: 12),),
      tileColor: Colors.grey,
    );
  }
}