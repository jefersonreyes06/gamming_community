import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/View/community_page.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/src/models/communities.dart';

//import '../src/models/chatServices.dart';

class StreamBuilderJoined extends StatefulWidget
{
  StreamBuilderJoined({super.key});

  @override
  State<StreamBuilderJoined> createState() => StreamBuilderState();
}

class StreamBuilderState extends State<StreamBuilderJoined>
{
  final communitiesProvider = CommunitiesProvider();
  final FirebaseAuth user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
        stream: communitiesProvider.getAllJoinedCommunitiesStream(
            user.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<String> communitiesIds = snapshot.data!;

          if (communitiesIds.isEmpty) {
            return Center(
                child: Text("Don`t have a community? Search one right now"));
          }

          return StreamBuilder(
              stream: communitiesProvider.getCommunitiesById(communitiesIds),
              builder: (context, communitiesSnapshot) {
                if (communitiesSnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${communitiesSnapshot.error}'));
                }
                if (communitiesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!communitiesSnapshot.hasData ||
                    communitiesSnapshot.data!.isEmpty) {
                  return Center(child: Text(
                      "Don`t have a community? Search one right now"));
                }
                final communities = communitiesSnapshot.data;

                return ListView.builder(
                    itemCount: communitiesSnapshot.data!.length,
                    itemBuilder: (context, i) {
                      final community = communities![i];

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
                                        CircleAvatar(radius: 18,
                                            child: community.cover == ""
                                                ? Icon(
                                                Icons.videogame_asset_rounded)
                                                : Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                    child: Image.network(community.cover, fit: BoxFit.cover,)))
                                        ),
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
                                                    .lastMessage}" ??
                                                    "No messages",
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
                );
              }
          );
        }
    );
  }
}