import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/Provider/community/communities_provider.dart';
import 'package:game_community/Widgets/custom_card.dart';
import 'package:game_community/src/models/communities.dart';

class Stream_Builder extends ConsumerStatefulWidget
{
  const Stream_Builder({super.key});

  @override
  ConsumerState<Stream_Builder> createState() => Stream_BuilderState();
}

class Stream_BuilderState extends ConsumerState<Stream_Builder>
{
  final Map<String, bool> _memberShipCache = {};
  final FirebaseAuth user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final communities = ref.watch(allCommunitiesProvider);

    return communities.when(
        data: (communities) => ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, i) {
              final Communities community = communities[i];

              final communityId = community.id;

              if (!_memberShipCache.containsKey(communityId)) {
                _checkMemberShip(communityId, user.currentUser!.uid);
              }

              return CustomCard(
                  community: community, isMember: _memberShipCache[communityId] ?? false,
                  onToggleMemberShip: () => _toggleMemberShip(community, user.currentUser!.uid)
              );
            }
        ),
        error: (e, _) => Text(e.toString()),
        loading: () => CircularProgressIndicator()
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

    void _toggleMemberShip(Communities community, String userId) async {
      final currentStatus = _memberShipCache[community.id] ?? false;
      //print("Toggle eject $currentStatus");


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
          'name': community.name,
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
