import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/core/firebase/storage_repository.dart';
import 'package:game_community/features/auth/auth_provider.dart';
import 'package:game_community/features/user/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/features/communities/state/communities_provider.dart';
import '../../../core/firebase/storage/widgets/custom_icon.dart';
import '../../../core/shared/widgets/custom_feet.dart';
import 'EditProfilePage.dart';

class ProfilePage extends ConsumerWidget {
  final String followId;

  const ProfilePage({super.key, required this.followId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final followTextController = TextEditingController();
    //final auth = ref.watch(authRepositoryProvider,); // Functions such as Log out account provider by Auth
    final uid = ref.watch(authStateProvider.select((state) => state.value!.id));
    //final user = ref.watch(userProvider(uid));
    final isFollowingAsync = ref.watch(isFollowingProvider(followId));

    final followingsCount = ref.watch(followingsCountProvider(followId));
    if (followingsCount.isLoading) return Center(child: CircularProgressIndicator());
    if (followingsCount.hasError) return Text(followingsCount.error.toString());

    //final userProv = ref.watch(userProvider()
    //final userProv = ref.watch(userProvider()
    final userProv = ref.watch(userProvider(followId));
    final userRepositoryProv = ref.watch(userRepositoryProvider);
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
                              "images/$followId/${user.profilePath}",
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
                                    Text(
                                      followingsCount.value!.followers.toString() ?? '0',
                                    ),

                                    SizedBox(width: 12),
                                    Text("Following: "),
                                    Text(
                                      followingsCount.value!.following.toString() ?? '0',
                                    ),
                                  ],
                                ),
                                // Follow
                                TextButton(
                                  onPressed: () async {
                                    if (isFollowingAsync.value == true) {
                                      await userRepositoryProv.unfollowUser(uid, followId);
                                    } else {
                                      await userRepositoryProv.followUser(uid, followId);
                                    }
                                  },
                                  child: Text(isFollowingAsync.value == true ? 'Unfollow' : 'Follow',
                                  ),
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
                ],
              ),
            );
          },
          error: (e, _) => Text(e.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),

      bottomNavigationBar: CustomFeet(),
    );
  }
}
