import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Provider/auth.dart';
import 'package:go_router/go_router.dart';

import '../Widgets/custom_feet.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{
  Auth currentUser = Auth();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(

        child: Column(
          children: [
            Text("Email: ${auth.currentUser!.email}"),
            Text("Name: ${auth.currentUser!.displayName}"),
            TextButton(onPressed: (){ auth.signOut(); context.go('/login'); }, child: Text('Log out')),
          ],
        )

      ),
        bottomNavigationBar: CustomFeet()
    );
  }

}