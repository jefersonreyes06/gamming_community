import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? description;
  final String? profilePath;
  final List<String>? communityIds;
  final List<String>? followers;
  final List<String>? following;
  final List<String>? posts;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.profilePath,
    required this.communityIds,
    required this.followers,
    required this.following,
    required this.posts,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('User data is null');
    }

    return UserModel(
      id: doc.id,
      email: data['email'] as String? ?? "",
      name: data['name'] as String? ?? "",
      description: data['description'] as String? ?? "",
      profilePath: data['profilePath'] as String? ?? "",
      communityIds: _parseStringList(data['communityIds']),
      followers: _parseStringList(data['followers']),
      following: _parseStringList(data['following']),
      posts: _parseStringList(data['posts']),
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return [];
  }

  Map<String, dynamic> toJson () {
    return {
      'name': name,
      'email': email,
      'description': description,
      'profilePath': profilePath,
      'communityId': communityIds,
      'followers': followers,
      'following': following,
      'posts': posts,
    };
  }

  UserModel copyWith({
    String? email,
    String? name,
    String? description,
    String? profilePath,
    List<String>? communityId,
    List<String>? followers,
    List<String>? following,
    List<String>? posts,

  }) {
    return UserModel(
        email: email ?? this.email,
        name: name ?? this.name, description: description ?? this.description,
        profilePath: profilePath ?? this.profilePath, id: id,
        communityIds: communityId ?? communityIds, followers: followers ?? this.followers,
        following: following ?? this.following, posts: posts ?? this.posts
    );
  }

  @override
  List<Object?> get props => [
    email, name, description, profilePath, id, communityIds, followers, following, posts
  ];
}