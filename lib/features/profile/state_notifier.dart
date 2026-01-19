import 'package:flutter_riverpod/legacy.dart';
import '../../core/firebase/storage_repository.dart';
import 'dart:io';

class UploadState {
  final bool isUploading;
  final double progress;
  final String? downloadUrl;
  final String? error;

  UploadState({
    this.isUploading = false,
    this.progress = 0.0,
    this.downloadUrl,
    this.error,
  });

  UploadState copyWith({
    bool? isUploading,
    double? progress,
    String? downloadUrl,
    String? error,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      error: error ?? this.error,
    );
  }
}

class UploadNotifier extends StateNotifier<UploadState> {
  final MediaUploadService _uploadService;

  UploadNotifier(this._uploadService) : super(UploadState());

  Future<void> uploadImage(File file, String userId) async {
    state = state.copyWith(isUploading: true, error: null);

    try {
      final url = await _uploadService.uploadImage(file, userId);
      state = state.copyWith(
        isUploading: false,
        downloadUrl: url,
        progress: 1.0,
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
      );
    }
  }
}

final uploadNotifierProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  final uploadService = ref.watch(mediaUploadServiceProvider);
  return UploadNotifier(uploadService);
});