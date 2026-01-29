import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/user/user_model.dart';
import '../auth/auth_provider.dart';
import 'user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Map<String, UserModel> usersCache = <String, UserModel>{};

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(FirebaseFirestore.instance);
});

final userProvider = FutureProvider.family<UserModel?, String?>((ref, uid) async {
  if (uid == null) {
    print('User is null');
  }

  final repository = ref.watch(userRepositoryProvider);

  return repository.getUser(uid!);
});

final updateUserProvider = FutureProvider.family<void, UserModel>((ref, user) async {
  final repository = ref.watch(userRepositoryProvider);

  await repository.updateUser(user);
});

final allUsersProvider = FutureProvider.family<UserModel, String>((ref, uid) async {
  if (usersCache.containsKey(uid)) {
    print('Data was obtained from cache');
    return usersCache[uid]!;
  }

  try {
    // USA .future en lugar de .watch() para evitar re-builds
    final user = await ref.read(userProvider(uid).future);
    usersCache[uid] = user!;
    print('User cached: ${user.id}');

    print('Map global: ${usersCache}');



    return user;
  } catch (e) {
    print('Error fetching user: $e');
    rethrow;
  }
});

final followUserProvider = FutureProvider.family<void, ({String uid, String followId})>((ref, params) async {
  final repository = ref.watch(userRepositoryProvider);

  repository.followUser(params.uid, params.followId);
});

final isFollowingProvider = StreamProvider.family<bool, String>((ref, targetUserId) {
  final firestore = FirebaseFirestore.instance;
  final currentUserId = ref.watch(currentUserUidProvider);

  return firestore
      .collection('users')
      .doc(currentUserId)
      .collection('following')
      .doc(targetUserId)
      .snapshots()
      .map((doc) => doc.exists);
});

final followingsCountProvider = StreamProvider.family<({int followers, int following}), String>((ref, userId) {
  final userProv = ref.watch(userRepositoryProvider);
  return userProv.getFollowingsCount(userId);
});