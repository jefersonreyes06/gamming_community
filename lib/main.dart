import 'package:flutter/material.dart';
import 'package:game_community/View/home_page.dart';
import 'package:game_community/View/login_page.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async
{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp.router(
      routerConfig: GoRouter(
        /*redirect: (context, state){
          final freeRoutes = ['register'];

          return freeRoutes.contains(state.fullPath) ? null : '/login';
        },*/
        initialLocation: '/home',
        routes: [
          GoRoute(path: '/home', name: 'home', builder: (context, state) => HomePage()),
          GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginPage()),
          GoRoute(path: '/register', name: 'register', builder: (context, state) => LoginPage()),
        ]
      ),
      debugShowCheckedModeBanner: false
    );
  }
}
