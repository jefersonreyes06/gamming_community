import 'package:flutter/material.dart';

class CustomIconStorage extends StatelessWidget {
  // I need to put a parameter as double for the size of the image
  final double radius;
  //final double size;
  final Future consult;

  const CustomIconStorage({super.key, required this.consult, required this.radius});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: consult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
                radius: radius,
                backgroundColor: const Color(0xFF1A1A1F),
            );
          }
          if (snapshot.hasError) {
            return CircleAvatar(
                radius: radius,
                backgroundColor: const Color(0xFF4A0B08),
            );
          }
          if (!snapshot.hasData) {
            return const Text('No profile');
          }
          return CircleAvatar(
              radius: radius,
              backgroundColor: const Color(0xFF1A1A1F),
              backgroundImage: NetworkImage(snapshot.data!, scale: 1,)
          );
        }
    );
  }
}