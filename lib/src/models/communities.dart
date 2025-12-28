import 'package:cloud_firestore/cloud_firestore.dart';

class Communities
{
  final String id;
  final String name;
  final String cover;
  final String description;
  final String userMessage;
  final String lastMessage;
  final int membersCount;
  final int onlineCount;
  final bool belong;

  Communities({
    required this.id,
    required this.name,
    this.cover = "",
    required this.description,
    this.userMessage = '',
    this.lastMessage = "",
    this.membersCount = 0,
    this.onlineCount = 0,
    this.belong = false,
  });

  factory Communities.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Communities(
      id: doc.id,
      name: data['name'],
      cover: data['cover'] ?? "",
      description: data['description'] ?? "",
      userMessage: data['userMessage'] ?? "",
      lastMessage: data['lastMessage'] ?? "",
      membersCount: data['membersCount'] ?? 0,
      onlineCount: data['onlineCount'] ?? 0,
      belong: data['belong'] ?? false,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'name': name,
      'cover': cover,
      'description': description,
      'lastMessage': lastMessage,
      'userMessage': userMessage,
      'membersCount': membersCount,
      'onlineCount': onlineCount,
      'belong': belong
    };
  }
}

class Message
{
  //final String id;
  final String texto;
  final String usuarioId;
  final String usuarioNombre;
  final DateTime createdAt;

  Message({
    //required this.id,
    required this.texto,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.createdAt,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      //id: doc.id,
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