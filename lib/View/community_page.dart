import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Widgets/app_bar.dart';
import 'package:game_community/Widgets/custom_icon.dart';
import 'package:game_community/Widgets/custom_text_field.dart';
import 'package:game_community/Widgets/stream_builder_community.dart';
import 'package:game_community/src/models/chatServices.dart';
import 'package:go_router/go_router.dart';

class CommunityPage extends StatefulWidget {
  final String communityId;
  final Map<String, dynamic> communityData;

  const CommunityPage({
    super.key,
    required this.communityId,
    required this.communityData,
  });

  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  final ChatService _chatService = ChatService();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 39,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(),
        ),
        backgroundColor: Color(0xFF1A1A1F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 0,
          children: [
            CustomIcon(
              cover: widget.communityData['cover'],
              iconSize: 18,
              radius: 20,
            ),
            SizedBox(width: 15),
            Text("${widget.communityData['name']}"),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () async {
              // Mostrando alerta de confirmación
              bool shouldLeave = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Salir de la comunidad'),
                    content: Text(
                      '¿Estás seguro de que quieres salir de la comunidad?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // No salir
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirmar salida
                        },
                        child: Text('Sí'),
                      ),
                    ],
                  );
                },
              );

              if (shouldLeave == true) {
                // Llamar al servicio para salir de la comunidad
                await _chatService.leaveCommunity(
                  communityId: widget.communityId,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                );

                // Cerrar la página actual usando GoRouter
                context.pop(); // o GoRouter.of(context).pop();
              }
            },
            icon: Icon(Icons.exit_to_app_rounded),
          ),
        ],
      ),

      body: StreamBuilderCommunity(communityId: widget.communityId),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        transformAlignment: Alignment.center,
        alignment: Alignment.center,
        height: 80,
        width: 150,
        decoration: BoxDecoration(color: Color(0xFF1A1A1F)),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Divider(),
            CustomTextField(
              label: "Write a message",
              height: 28,
              width: 280,
              hint: "Write something...",
              controller: messageController,
              borderRadius: 20,
            ),

            IconButton(
              onPressed: () {
                if (FirebaseAuth.instance.currentUser?.displayName != null) {
                  _chatService.sendMessage(
                    comunidadId: widget.communityId,
                    texto: messageController.text,
                    usuarioId: FirebaseAuth.instance.currentUser!.uid,
                    usuarioNombre:
                        "${FirebaseAuth.instance.currentUser!.displayName}",
                  );
                  messageController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "You must write a name user to send a message",
                      ),
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    ),
                  );
                }
              },
              icon: Icon(Icons.send, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
