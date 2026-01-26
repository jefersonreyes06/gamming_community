import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/features/chat/widgets/custom_icon.dart';
import 'package:game_community/features/communities/state/communities_provider.dart';
import 'package:go_router/go_router.dart';

import '../communities.dart';

class CustomCard extends ConsumerStatefulWidget {
  final Communities community;
  final bool isMember;
  final VoidCallback onToggleMemberShip;
  final int memberCount;

  const CustomCard({
    super.key,
    required this.community,
    required this.isMember,
    required this.onToggleMemberShip,
    required this.memberCount,
  });

  @override
  CustomCardState createState() => CustomCardState();
}

class CustomCardState extends ConsumerState<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(membersCountProvider(widget.community.id))
        .when(
          data: (count) => Card(
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
                context.push('/community/$id', extra: widget.community);
              },

              title: Text(widget.community.name),

              // I believe there’s a more efficient approach to this fix that would reduce
              // costs and follow better coding practices.
              subtitle: Text(
                "Members: ${ref.watch(membersCountProvider(widget.community.id)).value}",
              ),
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
          ),
          error: (e, _) => Text(e.toString()),
          loading: () => Center(),
         //Center(child: CircularProgressIndicator()),
        );
  }
}
