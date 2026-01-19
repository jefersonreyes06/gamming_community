import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../user/user_repository.dart';
import 'auth_repository.dart';

class AuthController {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  AuthController(this._authRepo, this._userRepo);

  Future<void> registerUser(String email, String password) async {
    final sessionUser = await _authRepo.register(
      email: email,
      password: password,
    );

    await _userRepo.createUserIfNotExists(sessionUser);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _authRepo.login(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
        serverClientId: "1000195925520-i7tabc9vhcanbnfj11qoujabkoso8p3g.apps.googleusercontent.com");

    final GoogleSignInAccount googleAuth = await googleSignIn.authenticate();

    final GoogleSignInAuthentication auth = googleAuth.authentication;
    String idToken = auth.idToken!;

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    await _authRepo.loginWithGoogle(credential);
  }
}