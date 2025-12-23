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