import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_community/core/shared/utils/utils.dart';
import '../message_model.dart';

class PopMenuButton extends StatelessWidget {
  final Message messageData;
  const PopMenuButton({
    super.key,
    required this.messageData,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'Update':

            break;
          case 'Delete':
            Utils.showConfirm(
              context: context,
              confirmButton: () {
                FirebaseFirestore.instance
                    .collection('communities')
                    .doc(messageData.id)
                    .collection('messages')
                    .doc(messageData.id)
                    .delete();
              },
            );
            break;
          default:
            return;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'Update', child: Text('Edit')),
        PopupMenuItem(value: 'Delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
      ],
      icon: Icon(Icons.more_vert_rounded, size: 18, color: Colors.black),
      padding: EdgeInsets.zero,
    );
  }
}

