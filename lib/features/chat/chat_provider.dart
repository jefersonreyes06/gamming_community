import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_repository.dart';
import 'message_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(FirebaseFirestore.instance);
});

final allMessagesProvider = StreamProvider.family<List<Message>, String>((ref, communityId) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getAllMessages(communityId);
});
