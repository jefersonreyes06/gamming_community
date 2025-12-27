import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_community/src/models/communities.dart';

class CommunitiesProvider
{
  Stream <List<Communities>> getAllCommunitiesStream() {
    final db = FirebaseFirestore.instance;
    final collectionRefCommunities = db.collection('communities');

    return collectionRefCommunities.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Communities.fromFirestore(doc);
      }).toList();
    });
  }

  Stream <List<String>> getAllJoinedCommunitiesStream(String userId) {
    final db = FirebaseFirestore.instance;
    final collectionRefCommunities = db.collection('users')
    .doc(userId).collection('communities');

    return collectionRefCommunities.snapshots().map((snapshot) =>
      snapshot.docs.map((d) => d['communityId'] as String).toList()
    );
  }

  Stream<List<Communities>> getCommunitiesById(List<String> ids) {
    if (ids.isEmpty) {
      return Stream.value([]);
    }

    final db = FirebaseFirestore.instance;
    return db.collection('communities').where(FieldPath.documentId, whereIn: ids).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Communities.fromFirestore(doc)).toList()
    );
  }

  Future <Stream> getAllMessages(String communityId) async
  {
    return FirebaseFirestore.instance
        .collection('communities')
        .doc(communityId)
        .collection("messages")
        .orderBy("CreatedAt", descending: false)
        .snapshots();
  }
  
  Stream <String?> getLastMessage(String communityId) {
    return FirebaseFirestore.instance
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .orderBy('CreatedAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return snapshot.docs.first['message'];
        });
  }
}