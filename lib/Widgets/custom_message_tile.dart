import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String userName;
  final String message;
  final String date;
  final Image icon;
  final bool unread;

  const MessageTile({
    super.key,
    required this.userName,
    required this.message,
    required this.date,
    required this.icon,
    this.unread = false,
  });
  @override
  Widget build(BuildContext context) {
    final bool isMe =
        userName == FirebaseAuth.instance.currentUser!.displayName;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// AVATAR (solo para otros)
                if (!isMe) ...[
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFB11226),
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
                              userName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            date,
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
                        message,
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
      ],
    );
  }
}
