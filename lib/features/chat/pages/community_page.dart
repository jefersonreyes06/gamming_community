import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/auth/auth_provider.dart';
import 'package:game_community/features/chat/widgets/custom_icon.dart';
import 'package:game_community/core/shared/widgets/custom_text_field.dart';
import 'package:game_community/features/chat/widgets/stream_builder_community.dart';
import 'package:game_community/features/user/user_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/firebase/storage_repository.dart';
import '../../../core/shared/services/image_picker_provider.dart';
import '../chat_provider.dart';

class CommunityPage extends ConsumerStatefulWidget {
  final String communityId;
  final Map<String, dynamic> communityData;

  const CommunityPage({
    super.key,
    required this.communityId,
    required this.communityData,
  });

  @override
  ConsumerState<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends ConsumerState<CommunityPage> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _chatRepositoryProvider = ref.read(chatRepositoryProvider);
    final _authRepositoryProvider = ref.watch(authRepositoryProvider);
    final _imagePickerRepositoryProvider = ref.watch(imagePickerServiceProvider);
    final auth = ref.watch(authStateProvider).value;
    final userName = ref.watch(userProvider(auth!.id));
    final storage = ref.watch(mediaUploadServiceProvider);

    print(auth!.name!);

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

                final user = ref.read(authStateProvider).value;
                  if (user != null) {
                    _chatRepositoryProvider.leaveCommunity(
                      communityId: widget.communityId,
                      userId: user.id,
                    );
                    context.pop();
                  }

              }

            },
            icon: Icon(Icons.exit_to_app_rounded,color: Colors.red),
          ),
        ],
      ),

      body: StreamBuilderCommunity(communityId: widget.communityId),


      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        transformAlignment: Alignment.center,
        alignment: Alignment.center,
        height: 80,
        width: 300,
        decoration: const BoxDecoration(color: Color(0xFF1A1A1F)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 0,

          children: [
            const Divider(),
            CustomTextField(
              label: "Write a message",
              height: 28,
              width: 280,
              hint: "Write something...",
              controller: messageController,
              borderRadius: 20,
            ),
            // Logic to send a message in a chat
            IconButton(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  _chatRepositoryProvider.sendMessage(
                    communityId: widget.communityId,
                    textMessage: messageController.text,
                    senderId: auth.id,
                    senderName: userName.value!.name!,
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
                onPressed: () async {
                  // Upload a file in the firebase storage
                  File? image = await _imagePickerRepositoryProvider.pickImage();

                  if (image != null) {
                    final url = await storage.uploadImage(image, auth!.id, 'images/${auth.id}');
                    _chatRepositoryProvider.saveFile(path: url, userId: auth.id, communityId: widget.communityId);
                  }
                },
                icon: Icon(Icons.attach_file, size: 22, color: Colors.white70,)
            )
          ],
        ),
      ),
    );
  }
}
