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