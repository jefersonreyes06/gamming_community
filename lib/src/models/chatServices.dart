import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_community/src/models/communities.dart';

class ChatService
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Enviar mensaje a una comunidad
  Future<void> sendMessage({
    required String comunidadId,
    required String texto,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    try {
      final mensaje = Message(
        id: '', // Firestore generará el ID
        texto: texto,
        usuarioId: usuarioId,
        usuarioNombre: usuarioNombre,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('communities')
          .doc(comunidadId)
          .collection('messages')
          .add(mensaje.toMap());

      await _firestore
      .collection('communities')
      .doc(comunidadId)
      .update({'userMessage': usuarioNombre, 'lastMessage': texto});

    } catch (e) {
      print('Error enviando mensaje: $e');
      rethrow;
    }
  }

  Stream<List<Message>> getAllMesagges(String comunidadId)
  {
    return _firestore
        .collection('communities')
        .doc(comunidadId)
        .collection('messages')
        .orderBy('CreatedAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromFirestore(doc))
        .toList());
  }

  Future<String?> getLastMessage(String comunidadId) async
  {
    final querySnapshot = await _firestore
        .collection('communities')
        .doc(comunidadId)
        .collection('messages')
        .orderBy('CreatedAt', descending: true)
        .limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      final lastMessageData = querySnapshot.docs.first.data();
      return lastMessageData['message'] as String?;
    }

    return "null";
  }

  Future<List<Message>> obtenerMensajesPaginados({
    required String comunidadId,
    required int limite,
    DocumentSnapshot? ultimoDocumento,
  }) async {
    Query query = _firestore
        .collection('communities')
        .doc(comunidadId)
        .collection('messages')
        .orderBy('CreatedAt', descending: true)
        .limit(limite);

    if (ultimoDocumento != null) {
      query = query.startAfterDocument(ultimoDocumento);
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
    final querySnapshot = await _firestore.collection('communities').doc(community.id).collection('members')
        .where('userId', isEqualTo: userId).get();

    if (querySnapshot.docs.isEmpty)
    {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('communities')
          .doc(community.id)
          .set({'communityId': community.id, 'name': community.name, 'joinedAt': FieldValue.serverTimestamp()});

      await _firestore
          .collection('communities')
          .doc(community.id)
          .collection('members')
          .doc(userId)
          .set({'userId': userId, 'joinedAt': FieldValue.serverTimestamp()});
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You are already in this community"),
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        )
      );
    }

  }

  // Salir de una comunidad
  Future<void> salirDeComunidad({
    required String comunidadId,
    required String usuarioId,
  }) async {
    await _firestore
        .collection('comunidades')
        .doc(comunidadId)
        .update({
      'members': FieldValue.arrayRemove([usuarioId])
    });
  }
}