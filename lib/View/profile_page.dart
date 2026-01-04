import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/Provider/storage/storage_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/Provider/community/communities_provider.dart';
import '../Widgets/custom_feet.dart';

class ProfilePage extends ConsumerWidget {
  ProfilePage({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = auth.currentUser;
    final joinedCommunities = ref.watch(joinedCommunitiesProvider(user!.uid));
    final profile = ref.watch(getPostsProvider);
    final _storage = FirebaseStorage.instance;


    Future<String> getImageUrl() async {
      try {
        String path = 'images/oRkYDxGsRaeuLOWpSGBUraKuEf42/oRkYDxGsRaeuLOWpSGBUraKuEf42_1767412171075.jpg';
        Reference ref = _storage.ref().child(path);
        String url = await ref.getDownloadURL();
        return url;
      }
      catch (e) {
        throw Exception('Upload failed $e');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            FutureBuilder(
                future: getImageUrl(),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    radius: 45,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(snapshot.data!)
                        : null,
                    child: user.photoURL == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  );
                }),

            const SizedBox(height: 12),

            // Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.displayName ?? "User",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {
                    context.push('/edit-profile');
                  },
                ),
              ],
            ),

            // Email
            Text(
              user.email ?? "Without email",
              style: const TextStyle(color: Colors.grey),
            ),

            const Divider(height: 20),

            const ListTile(
              leading: Icon(Icons.groups),
              title: Text("My communities"),
            ),

            // My communities
            Expanded(
                child: joinedCommunities.when(
                    data: (communities) =>
                        ListView.builder(
                            itemCount: communities.length,
                            itemBuilder: (context, i) {
                              final community = communities[i];
                              return ListTile(
                                contentPadding: const EdgeInsets.only(left: 40),
                                leading: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: community.cover.isNotEmpty
                                      ? NetworkImage(community.cover)
                                      : null,
                                  child: community.cover.isEmpty
                                      ? const Icon(Icons.groups, size: 16)
                                      : null,
                                ),
                                title: Text("${community.name} Community"),
                                onTap: () {
                                  context.push(
                                    '/community/${community.id}',
                                    extra: {
                                      'name': community.name,
                                      'cover': community.cover,
                                    },
                                  );
                                },
                              );
                            }
                        ),
                    error: (e, _) => Text(e.toString()),
                    loading: () => CircularProgressIndicator()
                )
            ),

            // Log out
            SafeArea(
              top: false,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Log out"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: const Text("Log out"),
                          content: const Text(
                            "Are you sure you want to log out?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await auth.signOut();
                                context.go('/login');
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFeet(),
    );
  }
}
