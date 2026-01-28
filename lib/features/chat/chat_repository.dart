import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_community/features/communities/communities.dart';
import 'message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  // Send message a community
  Future<void> sendMessage({
    required String communityId,
    required String senderName,
    required String senderId,
    required String textMessage,
  }) async {
    final docRef = _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .doc();

    docRef.set({
      'id': docRef.id,
      'senderId': senderId,
      'type': 'text',
      'text': textMessage,
      'media': null,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent',
    });

    await _firestore
        .collection('communities')
        .doc(communityId)
        .update({'senderName': senderName, 'lastMessage': textMessage});
  }

  Future<void> saveFile(
      {required String path, required String userId, required String communityId}) async {
    // Create a doc first to get the id
    final docRef = _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .doc();

    await docRef.set({
      'id': docRef.id,
      'senderId': userId,
      'type': 'file',
      'text': null,
      'media': {
        'url': path,
        'thumbnail': null,
        'width': 50,
        'height': 50,
        'size': 50,
        'duration': 0,
      },
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent'
    });

    // This will show that the user sent a file

    // Page code here!


  }

  Future<void> deleteMessage(
      {required String messageId, required String communityId}) async {
    try {
      await _firestore.collection('communities').doc(communityId).collection(
          'messages').doc(messageId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Message>> getAllMessages(String communityId) {
    return _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        print('Here are not docs to share');
        return [];
      }

      try {
        final messages = snapshot.docs.map((doc) {
          return Message.fromFirestore(doc);
        }).toList();

        return messages;
      } catch (e, stackTrace) {
        print('Error getting messages : $e');
        print('Stack trace: $stackTrace');
        return [];
      }
    });
  }

  Future<List<Message>> getPaginatedMessages({
    required String communityId,
    required int limit,
    DocumentSnapshot? lastDoc,
  }) async {
    Query query = _firestore
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .orderBy('CreatedAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Message.fromFirestore(doc))
        .toList()
        .reversed
        .toList();
  }

  // Unirse a una comunidad
  Future<void> joinCommunity({
    required Communities community,
    required String userId,
    required BuildContext context
  }) async {
    // If user is not a member in the community, then join
    final querySnapshot = await _firestore.collection('communities')
        .doc(community.id)
        .collection('members')
        .doc(userId)
        .get();

    if (querySnapshot.exists) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('communities')
          .doc(community.id)
          .set({
        'communityId': community.id,
        'name': community.name,
        'joinedAt': FieldValue.serverTimestamp()
      });

      await _firestore
          .collection('users')
          .doc(userId)
          .update({'communityIds': FieldValue.arrayUnion([community.id])});

      await _firestore
          .collection('communities')
          .doc(community.id)
          .collection('members')
          .doc(userId)
          .set({'userId': userId, 'joinedAt': FieldValue.serverTimestamp()});
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You are already in this community"),
            backgroundColor: const Color.fromARGB(255, 252, 0, 0),
          )
      );
    }
  }

  // Leave a community
  Future<void> leaveCommunity({
    required String communityId,
    required String userId,
  }) async {
    await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('members')
        .doc(userId)
        .delete();

    await _firestore
        .collection('users')
        .doc(userId)
        .update({'communityIds': FieldValue.arrayRemove([communityId])});

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('communities')
        .doc(communityId)
        .delete();
  }


  Future<void> joinOrLeaveCommunity({
    required Communities community,
    required String userId,
    required bool isMember
  }) async {
    if (isMember) {
      await _firestore
          .collection('communities')
          .doc(community.id)
          .collection('members')
          .doc(userId)
          .delete();

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('communities')
          .doc(community.id)
          .delete();
    }
    else {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('communities')
          .doc(community.id)
          .set({
        'communityId': community.id,
        'name': community.name,
        'joinedAt': FieldValue.serverTimestamp()
      });

      await _firestore
          .collection('communities')
          .doc(community.id)
          .collection('members')
          .doc(userId)
          .set({'userId': userId, 'joinedAt': FieldValue.serverTimestamp()});
    }
  }
}