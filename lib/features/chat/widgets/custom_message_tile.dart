import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/core/shared/utils/utils.dart';
import '../message_model.dart';

class MessageTile extends StatelessWidget {
  final Message messageData;
  final Image icon;
  final bool unread;

  const MessageTile({
    super.key,
    required this.messageData,
    required this.icon,
    this.unread = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = messageData.senderId == FirebaseAuth.instance.currentUser!.uid;
    print(messageData);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width * 0.7,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF1A1A1F) : const Color(0xFF121216),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: isMe ? const Radius.circular(14) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(14),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                // if i sent the message then a menu will appear to edit or delete the message
                if (isMe) {
                  // Mostrar menú simple con showMenu
                  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                  final button = context.findRenderObject() as RenderBox;

                  showMenu<String>(
                    context: context,
                    position: RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    ),
                    items: [
                      PopupMenuItem(value: 'delete', child: Text('Delete Message')),
                    ],
                  ).then((value) {
                    if (value == 'delete') {
                      Utils.showConfirm(
                        context: context,
                        confirmButton: () {
                          FirebaseFirestore.instance
                              .collection('communities')
                              .doc(messageData.id)
                              .collection('messages')
                              .doc(messageData.id)
                              .delete();
                          context.pop();
                        },
                      );
                    }
                  });
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isMe == false) ...[
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF1A1A1F),
                      child: icon,
                    ),
                    const SizedBox(width: 10),
                  ],

                  /// CONTENIDO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// Username + fecha
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                messageData.senderId,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              messageData.timestamp.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// MENSAJE
                        Text(
                          messageData.text.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDDDDDD),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}