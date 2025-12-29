import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Widgets/custom_icon.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:go_router/go_router.dart';

class CustomCard extends StatefulWidget {
  final DocumentSnapshot communityDoc;
  final bool isMember;
  final VoidCallback onToggleMemberShip;

  const CustomCard({
    super.key,
    required this.communityDoc,
    required this.isMember,
    required this.onToggleMemberShip,
  });

  @override
  CustomCardState createState() => CustomCardState();
}

class CustomCardState extends State<CustomCard> {
  final CommunitiesProvider communitiesProvider = CommunitiesProvider();
  int? memberCount = 0;

  @override
  void initState() {
    super.initState();
    updateCount();
  }

  void updateCount() async {
    int? count = await communitiesProvider.getNumberOfMembers(
      widget.communityDoc.id,
    );

    setState(() {
      memberCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          if (!widget.isMember) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Debes unirte a la comunidad para acceder al chat',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          final id = widget.communityDoc.id;
          final data = widget.communityDoc.data() as Map<String, dynamic>;

          context.push('/community/$id', extra: data);
        },

        title: Text(widget.communityDoc['name']),

        // I believe there’s a more efficient approach to this fix that would reduce
        // costs and follow better coding practices.
        subtitle: Text("Members: ${memberCount}"),
        leading: CustomIcon(
          cover: widget.communityDoc['cover'],
          iconSize: 22,
          radius: 13,
        ),
        trailing: TextButton(
          onPressed: widget.onToggleMemberShip,

          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              widget.isMember ? Colors.green : Colors.red,
            ),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          child: Text(widget.isMember ? "Leave" : "Join"),
        ),
      ),
    );
  }
}
