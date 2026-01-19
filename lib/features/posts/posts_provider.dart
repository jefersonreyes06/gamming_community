import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/firebase/storage_repository.dart';


final getPostsProvider = FutureProvider<dynamic>((ref) async {
  final repo = ref.read(mediaUploadServiceProvider);
  return repo.getImageUrl('images/oRkYDxGsRaeuLOWpSGBUraKuEf42/oRkYDxGsRaeuLOWpSGBUraKuEf42_1767412171075.jpg');
});
