import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

final customFeetProvider = StateProvider<int>((ref) => 0);

class CustomFeet extends ConsumerWidget
{
  const CustomFeet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1A1A1D),
      selectedItemColor: Colors.purpleAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: ref.watch(customFeetProvider),
      onTap: (index) {
        ref.read(customFeetProvider.notifier).state = index;

        if (index == 0) {
          context.go("/home");
        } else if (index == 1) {
          context.go("/search");
        } else if (index == 2) {
          context.go("/profile");
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: "Communities",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}