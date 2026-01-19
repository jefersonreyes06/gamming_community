import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/auth/auth_provider.dart';
import 'package:game_community/features/chat/pages/community_page.dart';
import 'package:game_community/features/communities/state/communities_provider.dart';
import 'package:game_community/features/user/user_provider.dart';
import '../../chat/widgets/custom_icon.dart';

class StreamBuilderJoined extends ConsumerStatefulWidget
{
  const StreamBuilderJoined({super.key});

  @override
  ConsumerState<StreamBuilderJoined> createState() => StreamBuilderState();
}

class StreamBuilderState extends ConsumerState<StreamBuilderJoined>
{
  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUserUidProvider); // Obtain userId
    final user = ref.watch(userProvider(uid)); // Obtain user data... path: users/{userId}
    if (user.isLoading) return CircularProgressIndicator();

    final List<String> communityIds = user.value!.communityIds; // Obtain communityIds from user data
    final joinedCommunities = ref.watch(joinedCommunitiesProvider(communityIds));

    return joinedCommunities.when(
        data: (communities) => ListView.builder(
          itemCount: communities.length,
          itemBuilder: (context, i) {

            final community = communities[i];

            return Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CommunityPage(communityId: community.id,
                                  communityData: community.toJson()),
                        ),
                      );
                    },

                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 2, horizontal: 13),
                        height: 45,
                        decoration: BoxDecoration(color: const Color(
                            0xFF323237), borderRadius: BorderRadius
                            .circular(20)),

                        child: Row(
                            spacing: 10,
                            children: [
                              CustomIcon(cover: community.cover,
                                  iconSize: 17.5, radius: 10),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,

                                        children: [
                                          Text(community.name,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .bold,
                                                color: Colors
                                                    .white70),),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,

                                              children: [
                                                Icon(Icons.circle,
                                                  size: 6.5,
                                                  color: Colors
                                                      .green,),
                                                Text("Online: 2",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors
                                                            .green))
                                              ]
                                          )
                                        ],
                                      ),
                                      Text(
                                        "${community
                                            .userMessage}:${community
                                            .lastMessage}",
                                        style: TextStyle(fontSize: 11,
                                            color: Colors.white70),
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ]
                                ),)
                            ]
                        )
                    )
                )
            );

          }
        ),
        error: (e, _) => Text('Error to load communities: ${e.toString()}'),
        loading: () => CircularProgressIndicator()
    );
  }
}