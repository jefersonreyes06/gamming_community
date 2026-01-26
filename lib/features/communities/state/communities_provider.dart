import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../communities.dart';
import '../community_repository.dart';

final communityRepositoryProvider = Provider((ref) => CommunityRepository(FirebaseFirestore.instance));

// Return an int that represents the number of members in a community
final membersCountProvider = FutureProvider.family<int, String>((ref, communityId) async {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getNumberOfMembers(communityId);
});

// Return a list of communities that the user is a member of
final joinedCommunitiesProvider = StreamProvider.family<List<Communities>, List<String>>((ref, communityIds) {
  final repo = ref.watch(communityRepositoryProvider);

  return repo.getJoinedCommunities(communityIds);
});

// Return a list of exists communities
final allCommunitiesProvider = FutureProvider<List<Communities>>((ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getAllCommunitiesStream();
});

/*
// Return the 4 first communities that match the key
final searchCommunitiesProvider = FutureProvider.family<List<Communities>, String>((ref, key) async {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getCommunityByKey(key);
});*/

// Return the 4 first communities that match the key
final searchCommunitiesProvider = FutureProvider.family<Communities, String>((ref, key) async {
  final repo = await ref.watch(communityRepositoryProvider);
  return repo.getCommunityByKey(key);
});