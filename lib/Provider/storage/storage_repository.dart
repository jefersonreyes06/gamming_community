import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final storageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

class MediaUploadService {
  final FirebaseStorage _storage;

  MediaUploadService(this._storage);
  final ImagePicker _picker = ImagePicker();

  Future<String> uploadImage(File file, String userId) async {
    try {
      // Generate a unique filename for the image
      String fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Reference to storage location
      Reference ref = _storage.ref().child('images/$userId/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Upload failed $e');
    }
  }

  Future<String> getImageUrl(String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      String url = await ref.getDownloadURL();
      return url;
    }
    catch (e) {
      throw Exception('Upload failed $e');
    }
  }

  Future<void> savePostWithImage(String imageUrl, String userId) async {
    await FirebaseFirestore.instance.collection('posts').add({
      'imageUrl': imageUrl,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

}

final mediaUploadServiceProvider = Provider((ref) =>
    MediaUploadService(FirebaseStorage.instance)
);

final getPostsProvider = FutureProvider<dynamic>((ref) async {
  final repo = ref.read(mediaUploadServiceProvider);
  return repo.getImageUrl('images/oRkYDxGsRaeuLOWpSGBUraKuEf42/oRkYDxGsRaeuLOWpSGBUraKuEf42_1767412171075.jpg');
});



