import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerService {
  final ImagePicker _picker;
  ImagePickerService(this._picker);

  // Choose an image from the gallery and return it as a File object
  Future<File?> pickImage() async {
    // Pick an image from the gallery as source, and set the values of certain parameters
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 80
    );

    // If an image was picked, return it as a File object
    if (image != null) return File(image.path);

    // If no image was picked, return null
    return null;
  }

  Future<File?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 80
    );

    if (photo != null) return File(photo.path);

    return null;
  }

  Future<File?> pickVideo() async {
    final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: Duration(minutes: 1)
    );

    if (video != null) return File(video.path);

    return null;
  }
}