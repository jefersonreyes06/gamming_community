import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/src/models/communities.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/Provider/communities_provider.dart';
import '../Widgets/custom_feet.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final communitiesProvider = CommunitiesProvider();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No hay usuario autenticado")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //Avatar
            CircleAvatar(
              radius: 45,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),

            const SizedBox(height: 12),

            //Nombre
            Text(
              user.displayName ?? "Sin nombre",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            //Email
            Text(
              user.email ?? "Sin email",
              style: const TextStyle(color: Colors.grey),
            ),

            const Divider(height: 40),

            //Opciones
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text("Mis comunidades"),
            ),

            Expanded(
              child: StreamBuilder<List<String>>(
                stream: communitiesProvider.getAllJoinedCommunitiesStream(
                  FirebaseAuth.instance.currentUser!.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(),
                    );
                  }
              
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text("No perteneces a ninguna comunidad"),
                    );
                  }
              
                  final communityIds = snapshot.data!;
              
                  return StreamBuilder(
                    stream: communitiesProvider.getCommunitiesById(communityIds),
                    builder: (context, communitiesSnapshot) {
                      return ListView.builder(
                        itemCount: communitiesSnapshot.data!.length,
                        itemBuilder: (context, i) {
                          Communities community = communitiesSnapshot.data![i];
                          return ListTile(
                            contentPadding: const EdgeInsets.only(left: 40),
                            leading: const Icon(Icons.circle, size: 8),
                            title: Text("Comunidad de ${community.name}"),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            const Spacer(),
            //Cerrar sesion
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar sesion"),
              onTap: () async {
                await auth.signOut();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFeet(),
    );
  }
}