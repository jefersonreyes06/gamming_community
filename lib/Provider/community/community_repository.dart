import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_community/src/models/communities.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository(this._firestore);

  Future <List<Communities>> getAllCommunitiesStream() async{
    final collectionRefCommunities = await _firestore.collection('communities').limit(8).get();

    return collectionRefCommunities.docs.map((doc) => Communities.fromFirestore(doc)).toList();
  }

  Stream <List<String>> getAllJoinedCommunitiesStream(String userId) {
    final db = FirebaseFirestore.instance;
    final collectionRefCommunities = db.collection('users')
        .doc(userId).collection('communities');

    return collectionRefCommunities.snapshots().map((snapshot) =>
        snapshot.docs.map((d) => d['communityId'] as String).toList()
    );
  }

  Stream <QuerySnapshot> getAllJoinedCommunities(String userId) {
    final db = FirebaseFirestore.instance;
    final collectionRefCommunities = db.collection('users')
        .doc(userId).collection('communities').snapshots();

    return collectionRefCommunities;
  }

  Stream<List<Communities>> getCommunitiesById(List<String> ids) {
    if (ids.isEmpty) {
      return Stream.value([]);
    }

    final db = FirebaseFirestore.instance;
    return db.collection('communities').where(
        FieldPath.documentId, whereIn: ids).snapshots().map(
            (snapshot) =>
            snapshot.docs.map((doc) => Communities.fromFirestore(doc)).toList()
    );
  }

  Stream<List<Message>> getAllMessages(String communityId) {
    return _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .orderBy('CreatedAt', descending: false)
        .limit(10)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<List<Communities>> getJoinedCommunities(String uid) async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      final userSource = userDoc.metadata.isFromCache ? 'CACHE' : 'SERVER';

      final userData = userDoc.data();
      if (!userDoc.exists || userData == null || !userData.containsKey('communityIds')) {
        return [];
      }

      final List<dynamic> communityIds = userData['communityIds'] ?? [];

      if (communityIds.isEmpty) {
        return [];
      }

      final communityFutures = communityIds.map((id) =>
          _firestore
              .collection('communities')
              .doc(id.toString())
              .get()
      ).toList();

      final communityDocs = await Future.wait(communityFutures);

      // 3️⃣ Convertir a objetos Community
      int fromCache = 0;
      int fromServer = 0;

      for (var doc in communityDocs) {
        if (doc.metadata.isFromCache) {
          fromCache++;
        } else {
          fromServer++;
        }
      }

      print('Communities breakdown:');
      print('From cache: $fromCache');
      print('From server: $fromServer');

      final realReads = (userDoc.metadata.isFromCache ? 0 : 1) + fromServer;
      print('Real reads charged: $realReads');

      return communityDocs.map((doc) => Communities.fromFirestore(doc)).toList();
    }
    catch (e) {
      print('Error loading communities: $e');
      return [];
    }
  }

  Future <int> getNumberOfMembers(String communityId) async
  {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('communities')
        .doc(communityId)
        .collection('members')
        .count()
        .get();

    return querySnapshot.count ?? 0;
  }
}