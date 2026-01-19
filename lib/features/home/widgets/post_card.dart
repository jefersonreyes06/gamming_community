import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A1D),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User123',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Just reached Diamond rank! 🎮🔥',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.redAccent),
                const SizedBox(width: 8),
                Icon(Icons.comment, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}