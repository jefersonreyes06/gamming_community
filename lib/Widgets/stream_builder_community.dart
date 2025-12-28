import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/src/models/communities.dart';
import 'package:game_community/src/models/chatServices.dart';

import 'custom_message_tile.dart';

class StreamBuilderCommunity extends StatelessWidget {
  final String communityId;

  StreamBuilderCommunity({super.key, required this.communityId});

  final communitiesProvider = CommunitiesProvider();
  final _chatServices = ChatService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: _chatServices.getAllMesagges(communityId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<Message> messages = snapshot.data ?? {};

          return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, i) {
                return MessageTile(
                  userName: messages[i].usuarioNombre,
                  message: messages[i].texto,
                  date: messages[i].createdAt.toString(),
                  icon: Image.network(FirebaseAuth.instance.currentUser!.photoURL ?? ""),
                  unread: true,
                );
              }
          );
        }

    );
  }
}