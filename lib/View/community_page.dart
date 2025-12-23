import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Widgets/app_bar.dart';
import 'package:game_community/Widgets/custom_feet.dart';
import 'package:game_community/Widgets/custom_search.dart';
import 'package:game_community/Widgets/custom_text_field.dart';
import 'package:game_community/Widgets/stream_builder_community.dart';
import 'package:game_community/Widgets/list_view.dart';
import 'package:game_community/src/models/chatServices.dart';

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
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: Encabezado(backgroundColor: Colors.black87, title: "${widget.communityData['name']}", actions: [IconButton(onPressed: (){}, icon: Icon(Icons.search))],),
      body: StreamBuilderCommunity(communityId: widget.communityId),
      bottomNavigationBar: Container(
        transformAlignment: Alignment.center,
        alignment: Alignment.center,
        height: 80,
        width: 150,
        decoration: BoxDecoration(color: Colors.grey,),

        child: Row(
          children: [
            CustomTextField(label: "Write a message", height: 40, width: 300, suffixIcon: Icons.send, hint: "Write something...", controller: messageController,),

            IconButton(
                onPressed: ()
                {
                  if (FirebaseAuth.instance.currentUser?.displayName != null)
                  {
                      _chatService.sendMessage(
                          comunidadId: widget.communityId,
                        texto: messageController.text,
                        usuarioId: FirebaseAuth.instance.currentUser!.uid,
                        usuarioNombre: "${FirebaseAuth.instance.currentUser!.displayName}"
                      );
                  }
                  else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("You must write a name user to send a message"),
                        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      )
                    );
                  }

                },
                icon: Icon(Icons.send))
        ])
      ),
    );
  }

}


