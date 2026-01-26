import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

class MediaUploadService {
  final FirebaseStorage _storage;

  MediaUploadService(this._storage);

  Future<String> uploadImage(File file, String userId, String? path) async {
    try {
      // Generate a unique filename for the image
      String fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Reference to storage location
      Reference ref = _storage.ref().child("$path/$fileName");

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
      throw Exception('Get image failed $e');
    }
  }
}

final mediaUploadServiceProvider = Provider((ref) =>
    MediaUploadService(FirebaseStorage.instance)
);



