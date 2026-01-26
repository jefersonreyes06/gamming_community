import 'package:cloud_firestore/cloud_firestore.dart';

class Communities
{
  final String id;
  final String name;
  final String cover;
  final String description;
  final String senderId;
  final String senderName;
  final String lastMessage;
  final int membersCount;
  final int onlineCount;

  Communities({
    required this.id,
    required this.name,
    this.cover = "",
    required this.description,
    this.senderName = "",
    this.senderId = '',
    this.lastMessage = "",
    this.membersCount = 0,
    this.onlineCount = 0,
  });

  factory Communities.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Communities(
      id: doc.id,
      name: data['name'],
      cover: data['cover'] ?? "",
      description: data['description'] ?? "",
      senderId: data['senderId'] ?? "",
      senderName: data['senderName'] ?? "",
      lastMessage: data['lastMessage'] ?? "",
      membersCount: data['membersCount'] ?? 0,
      onlineCount: data['onlineCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'name': name,
      'cover': cover,
      'description': description,
      'lastMessage': lastMessage,
      'senderId': senderId,
      'senderName': senderName,
      'membersCount': membersCount,
      'onlineCount': onlineCount,
    };
  }
}