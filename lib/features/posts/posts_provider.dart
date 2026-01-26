import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/firebase/storage_repository.dart';

final getPostsProvider = FutureProvider.family<String, String>((ref, path) async {
  final repo = ref.read(mediaUploadServiceProvider);
  return repo.getImageUrl(path);
});
