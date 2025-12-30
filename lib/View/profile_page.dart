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
            // Avatar
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

            // Nombre
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.displayName ?? "User",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {
                    context.push('/edit-profile');
                  },
                ),
              ],
            ),

            // Email
            Text(
              user.email ?? "Sin email",
              style: const TextStyle(color: Colors.grey),
            ),

            const Divider(height: 20),

            const ListTile(
              leading: Icon(Icons.groups),
              title: Text("Mis comunidades"),
            ),

            //Mis Comunidades
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: communitiesProvider.getAllJoinedCommunitiesStream(
                  FirebaseAuth.instance.currentUser!.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text("No perteneces a ninguna comunidad"),
                    );
                  }

                  final communityIds = snapshot.data!;

                  return StreamBuilder(
                    stream: communitiesProvider.getCommunitiesById(
                      communityIds,
                    ),
                    builder: (context, communitiesSnapshot) {
                      if (!communitiesSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final communities = communitiesSnapshot.data!;

                      return ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (context, i) {
                          final community = communities[i];
                          return ListTile(
                            contentPadding: const EdgeInsets.only(left: 40),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundImage: community.cover.isNotEmpty
                                  ? NetworkImage(community.cover)
                                  : null,
                              child: community.cover.isEmpty
                                  ? const Icon(Icons.groups, size: 16)
                                  : null,
                            ),
                            title: Text("Comunidad de ${community.name}"),
                            onTap: () {
                              context.push(
                                '/community/${community.id}',
                                extra: {
                                  'name': community.name,
                                  'cover': community.cover,
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // Cerrar Sesion
            SafeArea(
              top: false,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Cerrar sesión"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Cerrar sesión"),
                      content: const Text(
                        "¿Estás seguro de que deseas cerrar sesión?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await auth.signOut();
                            context.go('/login');
                          },
                          child: const Text(
                            "Sí",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFeet(),
    );
  }
}
