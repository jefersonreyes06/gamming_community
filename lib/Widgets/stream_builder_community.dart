import 'package:flutter/material.dart';
import 'package:game_community/Widgets/list_view.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/src/models/communities.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/src/models/chatServices.dart';

class StreamBuilderCommunity extends StatelessWidget
{
  final String communityId;

  StreamBuilderCommunity({super.key, required this.communityId});
  final communitiesProvider = CommunitiesProvider();
  final _chatServices = ChatService();

  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder<List<Message>>(
        stream: _chatServices.getAllMesagges(communityId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
        {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<Message> messages = snapshot.data ?? {};

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 6),

              itemCount: messages.length,
              
              itemBuilder: (BuildContext context, int i)
              {
                return Container(
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.center,
                    child: GestureDetector(
                        onLongPress: () { print("Presionaste mucho tiempo"); },
                        
                        child: Lista(
                            title: messages[i].usuarioNombre,
                            lastMessages: messages[i].texto,
                            padding: 0
                        )
                    )
                );
              }
          );
        }

    );
  }
}
