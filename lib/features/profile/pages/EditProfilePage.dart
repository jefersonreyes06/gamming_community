import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/user/user_model.dart';
import 'package:game_community/features/user/user_provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/shared/services/image_picker_provider.dart';
import '../../../core/shared/services/image_picker_repository.dart';
import '../../auth/auth_provider.dart';
import '../state_notifier.dart';
import '../../../core/firebase/storage_repository.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});
  //const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final bool _loading = false;

  MediaUploadService mediaUploadService = MediaUploadService(FirebaseStorage.instance);

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? '';
    _descriptionController.text = widget.user.description ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /*
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
  }*/

  @override
  Widget build(BuildContext context) {
    final mediaUploadService = ref.watch(mediaUploadServiceProvider);
    final uploadState = ref.watch(uploadNotifierProvider);
    final imagePicker = ref.read(imagePickerServiceProvider);
    final _auth = ref.read(currentUserUidProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: _loading ? null : () async {
              UserModel newUserData = UserModel (
                id: widget.user.id,
                email: widget.user.email,
                name: _nameController.text == '' ? widget.user.name : _nameController.text,
                description: _descriptionController.text == '' ? widget.user.description : _descriptionController.text,
                profilePath: widget.user.profilePath,
                communityIds: widget.user.communityIds,
                followers: widget.user.followers,
                following: widget.user.following,
                posts: widget.user.posts,
              );

              await ref.read(updateUserProvider(newUserData).future);
              ref.invalidate(userProvider(widget.user.id));

              if (mounted) {
                context.go('/myProfile');
              }
            },
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
                    ref.read(uploadNotifierProvider.notifier).uploadImage(file, _auth);
                  }
                },
                child: Text("Choose other profile picture")
            ),

            // USER NAME
            const Text(
              "User name:",
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

            // DESCRIPTION
            const Text(
              "Description:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLength: 200,
              decoration: const InputDecoration(
                hintText: "Enter the description of your profile",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
