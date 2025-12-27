import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/View/community_page.dart';
import 'package:game_community/Widgets/custom_card.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/src/models/communities.dart';

import '../src/models/chatServices.dart';

class Stream_Builder extends StatefulWidget
{
  Stream_Builder({super.key});

  State<Stream_Builder> createState() => Stream_BuilderState();
}

class Stream_BuilderState extends State<Stream_Builder>
{
  final communitiesProvider = CommunitiesProvider();
  final _chatServices = ChatService();
  final FirebaseAuth user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder< List<Communities> >(
        stream: communitiesProvider.getAllCommunitiesStream(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
        {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<Communities> communities = snapshot.data!;

          if (communities == null || communities.isEmpty) {
            return Center(child: Text("Don`t have a community? Search one right now"));
          }

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 6),
              padding: EdgeInsets.all(12),
              shrinkWrap: true,
              clipBehavior: Clip.none,

              itemCount: communities.length,
              itemBuilder: (BuildContext context, int i)
              {
                return Container(
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(20))),

                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute
                          (
                          builder: (context) =>
                              CommunityPage(
                                communityId: communities[i].id,
                                communityData: communities[i].toJson(),
                              ),
                        ),
                      );
                    },

                    child: CustomCard(
                      title: communities[i].name,
                      subtitle: '2',

                      isJoined: communities[i].belong == false ? "Join" : "Left",
                      community: communities[i],
                      userId: user.currentUser!.uid,
                    )
                  )
                );
              }
          );
        }
    );
  }
}
