import 'package:firebase_auth/firebase_auth.dart';
import '../../core/session/session_model.dart';
import '../user/user_provider.dart';
import 'auth_controller.dart';
import 'auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<SessionUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(
      ref.read(authRepositoryProvider),
      ref.read(userRepositoryProvider)
  );
});

final currentUserUidProvider = Provider<String>((ref) {
  return ref.watch(authStateProvider).value!.uid;
});

/*
final currentUserEmailProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.email;
});

final currentUserNameProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.displayName;
});
*/
//final authData =