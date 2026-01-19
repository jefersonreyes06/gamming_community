import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/session/session_model.dart';
import 'user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);


  Future<void> createUserIfNotExists(SessionUser user) async {
    final ref = _firestore.collection('users').doc(user.uid);

    final snapshot = await ref.get();

    if (snapshot.exists) return;

    await ref.set({
      'id': user.uid,
      'email': user.email,
      'name': user.displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromFirestore(doc);
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());
  }
}