import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../communities.dart';
import '../community_repository.dart';

final communityRepositoryProvider = Provider((ref) => CommunityRepository(FirebaseFirestore.instance));

final membersCountProvider = FutureProvider.family<int, String>((ref, communityId) async {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getNumberOfMembers(communityId);
});

final joinedCommunitiesProvider = StreamProvider.family<List<Communities>, List<String>>((ref, communityIds) {
  final repo = ref.watch(communityRepositoryProvider);

  return repo.getJoinedCommunities(communityIds);
});

final allCommunitiesProvider = FutureProvider<List<Communities>>((ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getAllCommunitiesStream();
});
