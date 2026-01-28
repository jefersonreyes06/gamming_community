import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_community/features/chat/pages/community_page.dart';
import 'package:game_community/features/home/pages/home_page.dart';
import 'package:game_community/features/auth/pages/login_page.dart';
import 'package:game_community/features/auth/pages/register_page.dart';
import 'package:game_community/features/communities/pages/search_page.dart';
import 'package:game_community/features/user/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/auth_provider.dart';
import 'features/profile/pages/my_profile.dart';
import 'features/profile/pages/profile_page.dart';
import 'package:game_community/core/theme/dark_gamer_theme.dart';
import 'features/profile/pages/EditProfilePage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await FirebaseAppCheck.instance.activate(
    providerAndroid: AndroidDebugProvider(),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: darkGamerTheme,
      routerConfig: GoRouter(
        redirect: (context, state) {
          final auth = ref.watch(authStateProvider);
          final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

          if (auth.asData?.value == null && !isAuthRoute) {
            return '/login';
          } else {
            return null;
          }
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
              final communityData = state.extra  as Map<String, dynamic>? ?? {};

              return CommunityPage(
                communityId: communityId,
                communityData: communityData,
              );
            },
          ),
          GoRoute(
              path: '/myProfile',
              name: 'myProfile',
              builder: (context, state) => const MyProfilePage(),
          ),
          GoRoute(
              path: '/profile/:id',
              name: 'profile',
              builder: (context, state) {
                final followUid = state.pathParameters['uid']!;

                return ProfilePage(followId: followUid);
              }
          ),
          GoRoute(
            path: '/edit-profile',
            builder: (context, state) {
              final user = ref.watch(userProvider(ref.read(currentUserUidProvider)));

              return EditProfilePage(user: user.value!);
              },
          ),
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
