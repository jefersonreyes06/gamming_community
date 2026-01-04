import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../src/models/communities.dart';
import 'community_repository.dart';

final communityRepositoryProvider = Provider((ref) => CommunityRepository(FirebaseFirestore.instance));

final membersCountProvider = FutureProvider.family<int, String>((ref, communityId) async {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getNumberOfMembers(communityId);
});

final joinedCommunitiesProvider = FutureProvider.family<List<Communities>, String>((ref, uid) async {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getJoinedCommunities(uid);
});

final allCommunitiesProvider = FutureProvider<List<Communities>>((ref) async {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getAllCommunitiesStream();
});

final allMessagesProvider = StreamProvider.family<List<Message>, String>((ref, communityId) {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getAllMessages(communityId);
});