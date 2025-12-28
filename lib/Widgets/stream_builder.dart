import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Widgets/custom_card.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/src/models/communities.dart';

class Stream_Builder extends StatefulWidget
{
  Stream_Builder({super.key});

  @override
  State<Stream_Builder> createState() => Stream_BuilderState();
}

class Stream_BuilderState extends State<Stream_Builder>
{
  final Map<String, bool> _memberShipCache = {};


  final communitiesProvider = CommunitiesProvider();
  final FirebaseAuth user = FirebaseAuth.instance;
  //final CustomCardState customCardState = CustomCardState();


  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder< QuerySnapshot >(
      stream: FirebaseFirestore.instance.collection('communities').snapshots(),
      builder: (context, communitySnapshot) {
        if (!communitySnapshot.hasData) { return Center(child: CircularProgressIndicator()); }

        //final Set<String> joinedCommunities = joinedSnapshot.data!.toSet();

        final List<QueryDocumentSnapshot> communities = communitySnapshot.data!.docs;

        return ListView.builder(
          itemCount: communities.length,
          itemBuilder: (context, i) {
            final QueryDocumentSnapshot community = communities[i];
            final communityId = community.id;

            if (!_memberShipCache.containsKey(communityId)) {
              _checkMemberShip(communityId, user.currentUser!.uid);
            }

            return CustomCard(communityDoc: community, isMember: _memberShipCache[communityId] ?? false,
                onToggleMemberShip: () => _toggleMemberShip(community, user.currentUser!.uid)
            );

          }
        );

        /*
        return StreamBuilder< List<Communities> >(
        stream: communitiesProvider.getAllCommunitiesStream(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<Communities> communities = snapshot.data!;

          if (communities.isEmpty) {
            return Center(child: Text("Don`t have a community? Search one right now"));
          }

          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                final community = communities[i];
                final bool isMember = joinedCommunities.contains(community.id);



                return Container(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: GestureDetector(
                        onTap: () {},

                        child: CustomCard(
                          title: community.name,
                          subtitle: '2',
                          isMember: isMember,
                          //isMember:  customCardState.updateIsMember(isMember);
                          community: community,
                          userId: user.currentUser!.uid,
                        )
                  )
                );
              }
          );
        });*/
      }
    );


  }

  void _checkMemberShip(String communityId, String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('communities')
        .doc(communityId)
        .collection('members')
        .doc(userId)
        .get();

    if (mounted) {
      setState(() {
        _memberShipCache[communityId] = doc.exists;
      });
    }
  }

    void _toggleMemberShip(QueryDocumentSnapshot community, String userId) async {
      final currentStatus = _memberShipCache[community.id] ?? false;
      print("Toggle eject $currentStatus");


      setState(() {
        _memberShipCache[community.id] = !currentStatus;
      });

      try{
        if (currentStatus) {
          await Future.wait([
            FirebaseFirestore.instance
              .collection('communities')
              .doc(community.id)
              .collection('members')
              .doc(userId)
              .delete(),

          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('communities')
              .doc(community.id)
              .delete(),
          ]);
        }
        else {
          await Future.wait([
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('communities')
              .doc(community.id)
              .set({
          'communityId': community.id,
          'name': community['name'],
          'joinedAt': FieldValue.serverTimestamp()
          }),

          FirebaseFirestore.instance
              .collection('communities')
              .doc(community.id)
              .collection('members')
              .doc(userId)
              .set({'userId': userId, 'joinedAt': FieldValue.serverTimestamp()}),
          ]);
        }
      }
      catch (e) {
        setState(() {
          _memberShipCache[community.id] = currentStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"),)
        );
      }
    }

}
