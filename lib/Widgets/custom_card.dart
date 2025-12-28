import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_community/src/models/communities.dart';

import '../src/models/chatServices.dart';

class CustomCard extends StatelessWidget {
  final DocumentSnapshot communityDoc;
  final bool isMember;
  final VoidCallback onToggleMemberShip;

  CustomCard({
    required this.communityDoc,
    required this.isMember,
    required this.onToggleMemberShip,
  });
  /*
  final String title;
  final String subtitle;
  final Communities community;
  final String userId;
  bool isMember;

  CustomCard({super.key, required this.title, required this.subtitle, required this.community, this.userId = "", this.isMember = false});
*/
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ChatService chatServices = ChatService();

  @override
  Widget build (BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(communityDoc['name']),
        subtitle: Text("Amount: 2"),
        trailing: TextButton(
          onPressed: onToggleMemberShip,
            /*onPressed: isLoading.value ? null : () async {
              isLoading.value = true;
              await chatServices.JoinOrLeaveCommunity(isMember: isMember, community: community, userId: userId);
              isLoading.value = false;
            },*/

          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.deepOrange)),
          child: Text(isMember ? "Leave" : "Join"),
        ),

      ),
    );
  }
}