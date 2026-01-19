import 'package:cloud_firestore/cloud_firestore.dart';

class PostsRepository {
  final FirebaseFirestore _store;

  PostsRepository(this._store);

  Future<void> createPost(String imageUrl, String userId) async {
    await _store.collection('posts')
      .add({'imageUrl': imageUrl, 'userId': userId, 'createdAt': FieldValue.serverTimestamp()});
  }
}