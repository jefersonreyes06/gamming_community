import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/user/user_model.dart';
import 'user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(FirebaseFirestore.instance);
});

final userProvider = FutureProvider.family<UserModel, String>((ref, uid) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(uid);
});
