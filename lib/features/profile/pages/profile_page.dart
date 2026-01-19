import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/auth/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/features/communities/state/communities_provider.dart';
import '../../../core/shared/widgets/custom_feet.dart';
import '../../user/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authRepositoryProvider);
    final uid = ref.watch(authStateProvider.select((state) => state.value!.uid));
    final name = ref.watch(authStateProvider.select((state) => state.value!.displayName));
    final email = ref.watch(authStateProvider.select((state) => state.value!.email));

    final user = ref.watch(userProvider(uid)); // Obtain user data... path: users/{userId}
    if (user.isLoading) return CircularProgressIndicator();
    final List<String> communityIds = user.value!.communityIds;

    final joinedCommunities = ref.watch(joinedCommunitiesProvider(communityIds));

    /*
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
*/
    return Scaffold(
      body: user.when(
          data: (user) {
            return SingleChildScrollView(
              child:
              Container(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              child: Column(
                  children: [
                    // Basic Info
                    Column(
                        children: [
                          // Profile, name, email, followers, following
                          Row(
                            children: [
                              Icon(Icons.person, size: 60,),
                              SizedBox(width: 10),
                              Container(
                                alignment: AlignmentGeometry.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name ?? "User", style: TextStyle(
                                        fontSize: 30, fontWeight: FontWeight.bold)),
                                    Text(email ?? "Without email",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 11.5),),
                                    Divider(),
                                    Row(
                                      children: [
                                        Text("Followers: "),
                                        Text(user.followers.length.toString()),

                                        SizedBox(width: 12),
                                        Text("Following: "),
                                        Text(user.following.length.toString()),
                                      ],
                                    ),
                                    Divider()
                                  ],
                                ),
                              )

                            ],
                          ),
                          Row(

                          ),
                          // Description
                          Container(
                            padding: EdgeInsets.all(3),
                            alignment: AlignmentGeometry.center,
                            decoration: BoxDecoration(color: Colors.black12),
                            child: Text("Description ${user.description} 😊", style: TextStyle(fontSize: 14)),
                          ),
                        ]
                    ),
                    // End Basic Info

                    // My Communities, Friends, Achievements, Notifications
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("My Communities"),
                          Row(children: [
                          Expanded(
                              child: SizedBox(
                                height: 170,
                                child: joinedCommunities.when(
                                  data: (communities) =>
                                      ListView.builder(
                                          itemCount: communities.length,
                                          itemBuilder: (context, i) {
                                            final community = communities[i];
                                            return ListTile(
                                              contentPadding: const EdgeInsets.only(
                                                  left: 40),
                                              leading: CircleAvatar(
                                                radius: 16,
                                                backgroundImage: community.cover
                                                    .isNotEmpty
                                                    ? NetworkImage(community.cover)
                                                    : null,
                                                child: community.cover.isEmpty
                                                    ? const Icon(
                                                    Icons.groups, size: 16)
                                                    : null,
                                              ),
                                              title: Text(
                                                  "${community.name} Community"),
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
                          ))
                          ]),
                          Divider(),
                          Row(
                              children: [
                                TextButton(onPressed: () {}, child: Text('Friends')),
                                TextButton(
                                    onPressed: () {}, child: Text('Achievements')),
                                TextButton(
                                    onPressed: () {}, child: Text('Notifications'))
                              ]
                          )
                        ],
                      ),
                    ),
                    // End My Communities
                    Divider(),

                    // My Posts
                    Column(
                        children: [
                        ]
                    ),
                    // End My Posts

                    Row(
                      children: [
                        Expanded(child:
                        SafeArea(
                          top: false,
                          child:
                          ListTile(
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
                                            await auth.logout();
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
                        )
                        ),

                        Expanded(child:
                        SafeArea(
                          top: false,
                          child: ListTile(
                            leading: const Icon(
                                Icons.settings_sharp, color: Colors.grey),
                            title: const Text("Settings"),
                            onTap: () {
                              /*
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
                                    await user.logout();
                                    context.go('/login');
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );*/
                            },
                          ),

                        ),
                        )

                      ],
                    )


                  ]
              ),
            )
            );
          },
          error: (e, s) => Text("Error $e"),
          loading: () => CircularProgressIndicator()
      ),



      bottomNavigationBar: CustomFeet(),


      /*
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
                    backgroundColor: Colors.white70,
                    /*backgroundImage: user.photoURL != null
                        ? NetworkImage(snapshot.data!)
                        : null,
                    child: user.photoURL == null
                        ? const Icon(Icons.person, size: 40)
                        : null,*/
                  );
                }),

            const SizedBox(height: 12),

            // Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name ?? "User",
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
              email ?? "Without email",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              uid,
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
            TextButton(onPressed: () => user.resetPassword(), child: Text("Reset password")),

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
                                await user.logout();
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
      bottomNavigationBar: CustomFeet(),*/
    );
  }
}
