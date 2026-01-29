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

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());
  }
  /*

  Future<int> getFollowersCount(String userId) async {
    final followersAmount = await _firestore.collection('users').doc(userId).collection('followers').count().get();

    return followersAmount.count ?? 0;
  }*/


  // I think is better use a Stream for all user profile
  Stream<({int followers, int following})> getFollowingsCount(String userId) {
    return _firestore.collection('users').doc(userId)
        .snapshots().map((doc) {
       final data = doc.data();
       return (
        followers: data?['followersCount'] as int? ?? 0,
        following: data?['followingCount'] as int? ?? 0);
    });
  }

  Future<void> followUser(String myId, String targetId) async {
    final batch = _firestore.batch();

    final followerRef = _firestore
        .collection('users')
        .doc(targetId)
        .collection('followers')
        .doc(myId);

    final followingRef = _firestore
        .collection('users')
        .doc(myId)
        .collection('following')
        .doc(targetId);

    final followersCountRef = _firestore.collection('users').doc(targetId);
    final followingCountRef = _firestore.collection('users').doc(myId);


    batch.update(followersCountRef, {'followersCount': FieldValue.increment(1)});
    batch.update(followingCountRef, {'followingCount': FieldValue.increment(1)});
    batch.set(followerRef, {'userId': myId});
    batch.set(followingRef, {'userId': targetId});

    await batch.commit();
  }

  Future<void> unfollowUser(String myId, String targetId) async {
    final batch = _firestore.batch();

    batch.delete(
      _firestore
          .collection('users')
          .doc(targetId)
          .collection('followers')
          .doc(myId),
    );

    batch.delete(
      _firestore
          .collection('users')
          .doc(myId)
          .collection('following')
          .doc(targetId),
    );

    final followersCountRef = _firestore.collection('users').doc(targetId);
    final followingCountRef = _firestore.collection('users').doc(myId);
    batch.update(followersCountRef, {'followersCount': FieldValue.increment(-1)});
    batch.update(followingCountRef, {'followingCount': FieldValue.increment(-1)});

    await batch.commit();
  }
}