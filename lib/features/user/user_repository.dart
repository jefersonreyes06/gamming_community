import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> createUserIfNotExists(UserModel user) async {
    final ref = _firestore.collection('users').doc(user.id);

    final snapshot = await ref.get();

    if (snapshot.exists) return;

    await ref.set({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromFirestore(doc);
  }

  /*
  Stream<UserModel> getUserStream(String uid) {
    final doc = _firestore.collection('users').doc(uid).snapshots().map((doc) => UserModel.fromFirestore(doc));

    return doc;
  }*/

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());
  }
}