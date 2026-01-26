import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/core/firebase/storage_repository.dart';
import 'package:game_community/features/auth/auth_provider.dart';
import 'package:game_community/features/user/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/features/communities/state/communities_provider.dart';
import '../../../core/firebase/storage/widgets/custom_icon.dart';
import '../../../core/shared/widgets/custom_feet.dart';

class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(
      authRepositoryProvider,
    ); // Functions such as Log out account provider by Auth
    final uid = ref.watch(authStateProvider.select((state) => state.value!.id));
    final userProv = ref.watch(userProvider(uid));
    if (userProv.isLoading) return Center(child: CircularProgressIndicator());
    final storage = ref.watch(
      mediaUploadServiceProvider,
    ); // API to get image from firebase storage and show it

    return Scaffold(
      body: SingleChildScrollView(
        child: userProv.when(
          data: (user) {
            final List<String> communityIds = user!.communityIds!;
            final joinedCommunities = ref.watch(
              joinedCommunitiesProvider(communityIds),
            );

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              child: Column(
                children: [
                  // Basic Info
                  Column(
                    children: [
                      // Profile, name, email, followers, following
                      Row(
                        children: [
                          CustomIconStorage(
                            consult: storage.getImageUrl(
                              "images/$uid/${user.profilePath}"
                            ),
                            radius: 36,
                          ),
                          //Icon(Icons.person, size: 60,),
                          SizedBox(width: 10),
                          Container(
                            alignment: AlignmentGeometry.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name ?? 'change name',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.email!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11.5),
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Text("Followers: "),
                                    Text(user.followers!.length.toString()),

                                    SizedBox(width: 12),
                                    Text("Following: "),
                                    Text(user.following!.length.toString()),
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(),
                      // Description
                      Container(
                        padding: const EdgeInsets.all(3),
                        alignment: AlignmentGeometry.center,
                        decoration: const BoxDecoration(color: Colors.black12),
                        child: Text(
                          "Description: ${user.description}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  // End Basic Info

                  // My Communities, Friends, Achievements, Notifications
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("My Communities"),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 170,
                                child: joinedCommunities.when(
                                  data: (communities) => ListView.builder(
                                    itemCount: communities.length,
                                    itemBuilder: (context, i) {
                                      final community = communities[i];
                                      return ListTile(
                                        contentPadding: const EdgeInsets.only(
                                          left: 40,
                                        ),
                                        leading: CircleAvatar(
                                          radius: 16,
                                          backgroundImage:
                                              community.cover.isNotEmpty
                                              ? NetworkImage(community.cover)
                                              : null,
                                          backgroundColor: const Color(
                                            0xFF535365,
                                          ),
                                          foregroundColor: Colors.black12,
                                          child: community.cover.isEmpty
                                              ? const Icon(
                                                  Icons.groups,
                                                  size: 16,
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          "${community.name} Community",
                                        ),
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
                                    },
                                  ),
                                  error: (e, _) => Text(e.toString()),
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Divider(),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text('Friends'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('Achievements'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('Notifications'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // End My Communities
                  Divider(),

                  // My Posts
                  Column(children: []),

                  // End My Posts
                  Row(
                    children: [
                      Expanded(
                        child: SafeArea(
                          top: false,
                          child: ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: const Text("Log out"),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
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

                                        if (context.mounted == true) {
                                          context.go('/login');
                                        }
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
                      ),

                      Expanded(
                        child: SafeArea(
                          top: false,
                          child: ListTile(
                            leading: const Icon(
                              Icons.settings_sharp,
                              color: Colors.grey,
                            ),
                            title: const Text("Settings"),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          error: (e, _) => Text(e.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
          /*
                        ]),
                        Divider(),
                        Row(
                            children: [
                              TextButton(
                                  onPressed: () {}, child: Text('Friends')
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text('Achievements')
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text('Notifications')
                              )
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

                                          if (context.mounted == true) {
                                            context.go('/login');
                                          }
                                        },
                                        child: const Text("Yes",
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

                      Expanded(
                        child: SafeArea(
                          top: false,
                          child: ListTile(
                            leading: const Icon(
                                Icons.settings_sharp, color: Colors.grey),
                            title: const Text("Settings"),
                            onTap: () {

                            },
                          ),

                        ),
                      )

                    ],
                  )
                ]
            ),
          )
      ),*/
        ),
      ),
      bottomNavigationBar: CustomFeet(),
    );
  }
}
