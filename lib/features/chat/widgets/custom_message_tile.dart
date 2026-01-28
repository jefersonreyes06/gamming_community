import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/profile/pages/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/core/shared/utils/utils.dart';
import '../../../core/firebase/storage/widgets/custom_icon.dart';
import '../../../core/firebase/storage_repository.dart';
import '../../auth/auth_provider.dart';
import '../../user/user_model.dart';
import '../chat_provider.dart';
import '../message_model.dart';

class MessageTile extends ConsumerWidget {
  final Message messageData;
  final UserModel userData;
  final String communityId;
  final String path;
  final bool unread;

  const MessageTile({
    super.key,
    required this.communityId,
    required this.userData,
    required this.messageData,
    required this.path,
    this.unread = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    final storage = ref.watch(mediaUploadServiceProvider);
    final chat = ref.watch(chatRepositoryProvider);

    return auth.when(
      data: (auth) {
        final bool isMe = messageData.senderId == auth!.id;

        if (messageData.type == MessageType.text) {
          return Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFF1A1A1F)
                        : const Color(0xFF121216),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: isMe
                          ? const Radius.circular(14)
                          : Radius.zero,
                      bottomRight: isMe
                          ? Radius.zero
                          : const Radius.circular(14),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Show simple menu
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject()
                              as RenderBox;
                      final RenderBox button =
                          context.findRenderObject() as RenderBox;

                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromRect(
                          Rect.fromPoints(
                            button.localToGlobal(
                              button.size.bottomRight(Offset.zero),
                              ancestor: overlay,
                            ),
                            button.localToGlobal(
                              button.size.bottomRight(Offset.zero),
                              ancestor: overlay,
                            ),
                          ),
                          Offset.zero & overlay.size,
                        ),
                        items: [
                          if (isMe) ...[
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete Message'),
                            ),
                          ],
                          PopupMenuItem(
                            value: 'profile',
                            child: Text('View Profile'),
                          ),
                        ],
                      ).then((value) {
                        if (context.mounted) {
                          if (isMe) {
                            if (value == 'delete') {
                              Utils.showConfirm(
                                context: context,
                                confirmButton: () {
                                  chat.deleteMessage(
                                    messageId: messageData.id,
                                    communityId: communityId,
                                  );
                                  context.pop();
                                },
                              );
                            }
                          } else if (value == 'profile') {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(followId: messageData.senderId),
                              ),
                            );
                          }
                        }
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isMe == false) ...[
                          CustomIconStorage(
                            consult: storage.getImageUrl(path),
                            radius: 25,
                          ),
                          const SizedBox(width: 10),
                        ],

                        /// Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Username + Date
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      userData.name!,
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

                              /// Message
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
        } else {
          return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              // I need to put a container as father
              child: Image.network(
                messageData.media!.url,
                scale: 0.46,
                width: 200,
                height: 200,
              ),
            );
        }
      },
      error: (e, _) => Text(e.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
