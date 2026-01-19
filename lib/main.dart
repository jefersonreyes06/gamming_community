import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_community/features/chat/pages/community_page.dart';
import 'package:game_community/features/home/pages/home_page.dart';
import 'package:game_community/features/auth/pages/login_page.dart';
import 'package:game_community/features/auth/pages/register_page.dart';
import 'package:game_community/features/communities/pages/search_page.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/session/session_provider.dart';
import 'features/profile/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_community/core/theme/dark_gamer_theme.dart';
import 'features/profile/pages/EditProfilePage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    return MaterialApp.router(
      theme: darkGamerTheme,
      routerConfig: GoRouter(
        redirect: (context, state) {
          final user = session.asData?.value;
          final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

          if (user == null && !isAuthRoute) {
            return '/login';
          }

          if (user != null && isAuthRoute) {
            return '/home';
          }
          return null;
        },
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: '/register',
            name: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/community/:id',
            name: 'community',
            builder: (context, state) {
              final communityId = state.pathParameters['id']!;
              final communityData = state.extra as Map<String, dynamic>? ?? {};

              return CommunityPage(
                communityId: communityId,
                communityData: communityData,
              );
            },
          ),
          GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
          GoRoute(
            path: '/edit-profile',
            builder: (context, state) => const EditProfilePage(),
          ),
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
