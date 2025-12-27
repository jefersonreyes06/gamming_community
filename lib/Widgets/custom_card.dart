import 'package:flutter/material.dart';
import 'package:game_community/src/models/communities.dart';

import '../src/models/chatServices.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String isJoined;
  final Communities community;
  final String userId;


  CustomCard({super.key, this.title = "", this.subtitle = "", this.isJoined = "", required this.community, this.userId = ""});

  ChatService chatServices = ChatService();

  @override
  Widget build (BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text("Amount: ${subtitle}"),
        trailing: TextButton(onPressed: () { chatServices.joinCommunity(community: community, userId: userId, context: context); }, child: Text(isJoined), style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.deepOrange)),),
      ),
    );
  }
}