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
    return Row(
        mainAxisAlignment: userName ==
            FirebaseAuth.instance.currentUser!.displayName
            ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.65,
              ),
              child: Container(

                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1D),
                  borderRadius: BorderRadius.circular(14),
                  border: unread
                      ? Border.all(color: Colors.purpleAccent.withOpacity(0.6))
                      : null,
                ),
                child: Row(
                  children: [

                    /// 👤 AVATAR
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7F00FF),
                            Color(0xFFE100FF),
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        child: icon,
                        //color: Colors.white,
                        radius: 22,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// 💬 MESSAGE CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// Username + Date
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          /// Message preview
                          Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔔 UNREAD DOT
                    if (unread) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.purpleAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),))
        ]
    );
  }
}