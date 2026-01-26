import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/user/user_model.dart';
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

/*
final allUsersProvider = FutureProvider<Map<String, UserModel>>((ref) async {
  final Map<String, UserModel> usersCache = <String, UserModel>{};

  return usersCache;
});*/

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

/*
final getUserCache = Provider.family<UserModel, String>((ref, uid) {
  print(uid);
  ref.watch(allUsersProvider).when(
        data: (usersCache) {
          try {
            if (usersCache.containsKey(uid)) {
              print('Data was obtained from cache');
              return usersCache[uid]!;
            } else {
              print('Data was obtained from firebase store and save in cache');
              final user = ref.watch(userProvider(uid));

              user.when(
                data: (user) {
                  usersCache[user.id] = user;
                },
                error: (e, _) => Text(e.toString()),
                loading: () => null,
              );

              return user.value;
            }
          } catch (e) {
            throw Exception(
              'Error getting user with the provider GetUserCache: $e',
            );
          }
        },
        error: (e, _) => Text(e.toString()),
        loading: () => null,
      );

  print('Se va nulo');
  return UserModel(
    id: '',
    email: '',
    name: '',
    description: '',
    profilePath: '',
    communityIds: [],
    followers: [],
    following: [],
    posts: [],
  );
});
*/