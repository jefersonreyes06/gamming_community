import 'package:flutter/material.dart';
import 'package:game_community/Widgets/list_view.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/src/models/communities.dart';
import 'package:game_community/src/models/chatServices.dart';

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
                return Container(
                  height: 75,
                  width: 150,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.center,
                    child: GestureDetector(
                        onLongPress: () {
                          print("Presionaste mucho tiempo");
                        },

                        child: Lista(
                            title: messages[i].usuarioNombre,
                            lastMessages: messages[i].texto,
                        )
                    )
                );
              }
          );
        }

    );
  }
}