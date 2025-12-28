import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Widgets/app_bar.dart';
import 'package:game_community/Widgets/custom_feet.dart';
import 'package:game_community/Widgets/custom_search.dart';
import 'package:game_community/Widgets/custom_text_field.dart';
import 'package:game_community/Widgets/stream_builder_community.dart';
import 'package:game_community/Widgets/list_view.dart';
import 'package:game_community/src/models/chatServices.dart';
import 'package:go_router/go_router.dart';

class CommunityPage extends StatefulWidget
{
  final String communityId;
  final Map<String, dynamic> communityData;

  const CommunityPage({super.key, required this.communityId, required this.communityData});

  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  final ChatService _chatService = ChatService();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Encabezado(
        backgroundColor: Colors.black87,
        title: "${widget.communityData['name']}",
        actions: [IconButton(
            onPressed: () {
              _chatService.leaveCommunity(communityId: widget.communityId,
                  userId: FirebaseAuth.instance.currentUser!.uid);
              context.pop();
            },
            icon: Icon(Icons.exit_to_app_rounded))
        ],
      ),

      body: StreamBuilderCommunity(communityId: widget.communityId),


      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          transformAlignment: Alignment.center,
          alignment: Alignment.center,
          height: 80,
          width: 150,
          decoration: BoxDecoration(color: Colors.grey,),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

              children: [
                CustomTextField(
                  label: "Write a message",
                  height: 40,
                  width: 300,
                  hint: "Write something...",
                  controller: messageController,),

                IconButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser?.displayName !=
                          null) {
                        _chatService.sendMessage(
                            comunidadId: widget.communityId,
                            texto: messageController.text,
                            usuarioId: FirebaseAuth.instance.currentUser!.uid,
                            usuarioNombre: "${FirebaseAuth.instance.currentUser!
                                .displayName}"
                        );
                        messageController.clear();
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "You must write a name user to send a message"),
                              backgroundColor: const Color.fromARGB(
                                  255, 255, 0, 0),
                            )
                        );
                      }
                    },
                    icon: Icon(Icons.send, size: 28,))
              ])
      ),
    );
  }

}


