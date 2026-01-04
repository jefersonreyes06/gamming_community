import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Provider/community/communities_provider.dart';
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
              return MessageTile(
                messageData: messages[i],
                icon: () {
                  try{
                    final String path = "letter-${messages[i].usuarioNombre.characters.first}.png";
                    return Image.asset("assets/$path", width: 60, height: 60, errorBuilder: (context, error, stackTrace) => Image.asset('assets/google.png', width: 60, height: 60),);
                  }
                  catch (e) {
                    Text("Error: $e");
                    return Image.asset('assets/google.png', width: 60, height: 60);
                  }
                }(),
                unread: true,
              );
            },
        ),
        error: (e, _) => Text(e.toString()),
        loading: () => CircularProgressIndicator()
    );
  }
}