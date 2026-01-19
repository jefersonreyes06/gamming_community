import 'package:firebase_auth/firebase_auth.dart';
import '../../core/session/session_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Stream<SessionUser?> authStateChanges() {
    return _auth.authStateChanges().map(_mapUser);
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

  SessionUser? _mapUser(User? user) {
    if (user == null) return null;

    return SessionUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
}