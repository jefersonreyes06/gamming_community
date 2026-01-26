import 'package:firebase_auth/firebase_auth.dart';
import '../user/user_model.dart';
import '../user/user_provider.dart';
import 'auth_controller.dart';
import 'auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});








//  Cambiar en un futuro!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return repository.authStateChanges();
});

/*final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return repository.authStateChanges();
});*/

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(
      ref.read(authRepositoryProvider),
      ref.read(userRepositoryProvider)
  );
});

final currentUserUidProvider = Provider<String>((ref) {
  return ref.watch(authStateProvider).value!.id;
});