import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Provider/storage/storage_repository.dart';
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

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  final ChatService _chatService = ChatService();
  //final StorageRepository _storageRepository = StorageRepository(FirebaseStorage.instance);
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
              // Showing a notification alert
              bool shouldLeave = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Leave Community?'),
                    content: Text(
                      'Are you sure you want to leave this community?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); 
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); 
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );

              if (shouldLeave == true) {
                await _chatService.leaveCommunity(
                  communityId: widget.communityId,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                );
                context.pop(); 
              }
            },
            icon: Icon(Icons.exit_to_app_rounded,color: Colors.red),
          ),
        ],
      ),

      body: StreamBuilderCommunity(communityId: widget.communityId),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        transformAlignment: Alignment.center,
        alignment: Alignment.center,
        height: 80,
        width: 300,
        decoration: BoxDecoration(color: Color(0xFF1A1A1F)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 0,

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
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
              onPressed: () {
                if (FirebaseAuth.instance.currentUser?.displayName != null && messageController.text.isNotEmpty) {
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
              icon: Icon(Icons.send, size: 22),
            ),
            IconButton(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                onPressed: () {},//{ _storageRepository.uploadImage(widget.communityId); },
                icon: Icon(Icons.attach_file, size: 22, color: Colors.white70,)
            )
          ],
        ),
      ),
    );
  }
}
