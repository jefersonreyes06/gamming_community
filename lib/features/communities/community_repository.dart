import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_community/features/communities/communities.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository(this._firestore);

  // I think is better option type the limit
  Future <List<Communities>> getAllCommunitiesStream() async{
    final collectionRefCommunities = await _firestore.collection('communities').limit(8).get();

    return collectionRefCommunities.docs.map((doc) => Communities.fromFirestore(doc)).toList();
  }
/*
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
 */

  //Future<List<Communities>> getCommunityByKey(String key) async {
  Future<Communities> getCommunityByKey(String key) async {
    final doc = await _firestore.collection('communities').where('keywords', arrayContains: key).limit(1).get();

    //return doc.docs.map((doc) => Communities.fromFirestore(doc)).toList();
    return doc.docs.map((doc) => Communities.fromFirestore(doc)).first;
  }

  Stream<List<Communities>> getJoinedCommunities(List<String> communityIds) {
    if (communityIds.isEmpty) {
      return Stream.value([]);
    }

    return _firestore.collection('communities')
        .where(FieldPath.documentId, whereIn: communityIds)
        .snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Communities.fromFirestore(doc)).toList()
    );
  }

  Future<int> getNumberOfMembers(String communityId) async
  {
    final querySnapshot = await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('members')
        .count()
        .get();

    return querySnapshot.count ?? 0;
  }
}