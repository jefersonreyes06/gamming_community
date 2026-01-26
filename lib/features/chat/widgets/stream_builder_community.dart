import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/user/user_provider.dart';
import '../../user/user_model.dart';
import '../chat_provider.dart';
import 'custom_message_tile.dart';

class StreamBuilderCommunity extends ConsumerWidget {
  final String communityId;
  const StreamBuilderCommunity({super.key, required this.communityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(allMessagesProvider(communityId));

    return messages.when(
        data: (messages) => ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, i) {
              final message = messages[i];
              final user = ref.watch(allUsersProvider(message.senderId));

              return user.maybeWhen(
                data: (user) => MessageTile(
                communityId: communityId,
                messageData: message,
                userData: user,
                path: () {
                  try {
                    return "images/${message.senderId}/${user.profilePath}";
                  } catch (e) {
                    throw Exception('Upload failed $e');
                  }
                }(),
                unread: true,
              ),
                orElse: () => Center(child: CircularProgressIndicator(),)
              );
            },
        ),
        error: (e, _) => Text(e.toString()),
        loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}