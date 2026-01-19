import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/services/image_picker_provider.dart';
import '../../../core/shared/services/image_picker_repository.dart';
import '../state_notifier.dart';
import '../../../core/firebase/storage_repository.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;
  MediaUploadService mediaUploadService = MediaUploadService(FirebaseStorage.instance);

  @override
  void initState() {
    super.initState();
    _nameController.text = _auth.currentUser?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save(String imageUrl, String userId) async {
    if (_nameController.text
        .trim()
        .isEmpty) return;

    setState(() => _loading = true);

    await _auth.currentUser!.updateDisplayName(
      _nameController.text.trim(),
    );

    await _auth.currentUser!.reload();
    //mediaUploadService.savePostWithImage(imageUrl, userId);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadNotifierProvider);
    final imagePicker = ref.read(imagePickerServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: _loading ? null : () {_save(uploadState.downloadUrl!, _auth.currentUser!.uid); },
            child: const Text("Save"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (uploadState.isUploading)
              CircularProgressIndicator(
                value: uploadState.progress,
              ),
            if (uploadState.error != null)
              Text('Error: ${uploadState.error}'),
            if (uploadState.downloadUrl != null)
              Image.network(uploadState.downloadUrl!),

            TextButton(
                onPressed: uploadState.isUploading ? null : () async {
                  final file = await imagePicker.pickImage();
                  if (file != null) {
                    ref.read(uploadNotifierProvider.notifier)
                        .uploadImage(file, _auth.currentUser!.uid);
                  }
                },
                child: Text("Choose other profile picture")
            ),
            const Text(
              "User name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              maxLength: 20,
              decoration: const InputDecoration(
                hintText: "Enter your user name",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
