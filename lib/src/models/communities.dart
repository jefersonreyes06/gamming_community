import 'package:cloud_firestore/cloud_firestore.dart';

class Communities
{
  final String id;
  final String name;
  final List<String> members;
  final String cover;
  final String description;
  final Map<String, dynamic> messages;

  Communities({
    required this.id,
    required this.name,
    required this.members,
    this.cover = "",
    required this.description,
    required this.messages,
  });

  factory Communities.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Communities(
      id: doc.id,
      name: data['name'] as String? ?? '',
      members: List<String>.from(data['members'] as List? ?? []),
      cover: data['cover'] as String? ?? '',
      description: data['description'] as String? ?? '',
      messages: Map<String, dynamic>.from(data['messages'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson()
  {
    return
      {
        'name': name,
        'members': members,
        'cover': cover,
        'description': description,
        'messages': messages,
      };
  }
}

class Message
{
  final String id;
  final String texto;
  final String usuarioId;
  final String usuarioNombre;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.texto,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.createdAt,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      texto: data['message'] ?? '',
      usuarioId: data['userId'] ?? '',
      usuarioNombre: data['user'] ?? '',
      createdAt: (data['CreatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': texto,
      'userId': usuarioId,
      'user': usuarioNombre,
      'CreatedAt': FieldValue.serverTimestamp(),
    };
  }
}