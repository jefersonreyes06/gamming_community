import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_community/features/user/user_provider.dart';
import 'package:game_community/features/user/user_repository.dart';
import '../user/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);
/*
  FutureProvider<UserModel?> get authStateChanges => FutureProvider<UserModel?>((ref) {
    final user = ref.watch(userProvider(_auth.currentUser!.uid)).when(
      data: (user) => user,
      error: (error, stackTrace) => null,
      loading: () => null,
    );
    return user;
  });
*/
  Stream<UserModel?> authStateChanges() {
    //return UserModel.fromFirestore(doc)
    //return userProvider();

    return _auth.authStateChanges().map(_mapUser);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userRepository = UserRepository(FirebaseFirestore.instance);
    final user = await userRepository.getUser(result.user!.uid);

    return user!;
  }

  Future<UserModel> loginWithGoogle(AuthCredential credential) async {
    final result = await _auth.signInWithCredential(credential);

    print("\nEste es el result de la autenticación con google: ${result.user}\n\n");


    return _mapUser(result.user)!;
  }

  Future<UserModel> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null) {
      await result.user!.updateDisplayName(displayName);
    }

    return _mapUser(result.user)!;
  }

  Future<void> resetPassword() async {
    await _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  UserModel? _mapUser(User? user) {
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      email: user.email,
      name: user.displayName,
      description: null,
      profilePath: null,
      communityIds: null,
      followers: null,
      following: null,
      posts: null,
    );
  }
}
/*
class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Stream<UserModel?> authStateChanges() {
    return  UserModel().toJson() _auth.authStateChanges()  .map(_mapUser);
  }

  Future<SessionUser> login({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _mapUser(result.user)!;
  }

  Future<SessionUser> loginWithGoogle(AuthCredential credential) async {
    final result = await _auth.signInWithCredential(credential);
    return _mapUser(result.user)!;
  }

  Future<SessionUser> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null) {
      await result.user!.updateDisplayName(displayName);
    }

    return _mapUser(result.user)!;
  }

  Future<void> resetPassword() async {
    await _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  UserModel? _mapUser(User? user) {
    if (user == null) return null;

    return SessionUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
}*/