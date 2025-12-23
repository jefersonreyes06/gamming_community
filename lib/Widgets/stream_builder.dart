import 'package:flutter/material.dart';
import 'package:game_community/View/community_page.dart';
import 'package:game_community/Widgets/list_view.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/src/models/communities.dart';
import 'package:go_router/go_router.dart';

import '../src/models/chatServices.dart';

class Stream_Builder extends StatefulWidget
{
  Stream_Builder({super.key});

  String getLastMessage(Communities community)
  {
    if (community.messages.isEmpty) return 'No messages';

    //late String lastMessage = community.


    return community.messages.entries.last.value ?? 'Empty message';
  }

  State<Stream_Builder> createState() => Stream_BuilderState();
}

class Stream_BuilderState extends State<Stream_Builder>
{
  final communitiesProvider = CommunitiesProvider();
  final _chatServices = ChatService();


  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder<List<Communities>>(
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
                final lastMessage = _chatServices.getLastMessage(communities[i].id);

                return Container(
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(20))),

                  child: GestureDetector(
                    onTap: ()
                    {
                      try
                      {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute
                            (
                            builder: (context) => CommunityPage(
                              communityId: communities[i].id,
                              communityData: communities[i].toJson(),
                            ),
                          ),
                        );

                      } catch (e) {
                        Navigator.of(context, rootNavigator: true).push
                          (
                          MaterialPageRoute
                            (
                            builder: (context) => CommunityPage(
                              communityId: communities[i].id,
                              communityData: communities[i].toJson(),
                            ),
                          ),
                        );
                      }
                    },

                    child: ListTile(
                        title: Text(communities[i].name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                        subtitle: StreamBuilder(
                            stream: communitiesProvider.getLastMessage(communities[i].id),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text(
                                "No messages",
                                style: TextStyle(fontSize: 9),
                                );
                              }

                              return Text(
                                snapshot.data!,
                                style: TextStyle(fontSize: 9),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                        ),


                        //Text("${ communitiesProvider.getLastMessage(communities[i].id).toString() }", style: TextStyle(fontSize: 9)),
                        minVerticalPadding: 0,
                      minTileHeight: 2.3,
                      //: 0,
                    )

                    /*Lista(
                        title: communities[i].name,
                        lastMessages: 'lastMessage',
                        padding: 0
                    )*/
                  )
                );
              }
          );
        }

    );
  }
}
