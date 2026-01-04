import 'package:flutter/material.dart';
import 'package:game_community/Widgets/custom_icon.dart';
import 'package:go_router/go_router.dart';

import '../src/models/communities.dart';

class CustomCard extends StatefulWidget {
  final Communities community;
  final bool isMember;
  final VoidCallback onToggleMemberShip;

  const CustomCard({
    super.key,
    required this.community,
    required this.isMember,
    required this.onToggleMemberShip,
  });

  @override
  CustomCardState createState() => CustomCardState();
}

class CustomCardState extends State<CustomCard> {
  int? memberCount = 0;

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
          final id = widget.community.id;
          //final data = widget.community.data() as Map<String, dynamic>;

          context.push('/community/$id', extra: widget.community);
        },

        title: Text(widget.community.name),

        // I believe there’s a more efficient approach to this fix that would reduce
        // costs and follow better coding practices.
        subtitle: Text("Members: $memberCount"),
        leading: CustomIcon(
          cover: widget.community.cover,
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
