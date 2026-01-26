import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/auth_provider.dart';
import '../../../features/profile/pages/profile_page.dart';

final customFeetProvider = StateProvider<int>((ref) => 0);

class CustomFeet extends ConsumerWidget
{
  const CustomFeet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    final currentUserUidProvider = ref.watch(authStateProvider).value!.id;
    final currentIndex = ref.watch(customFeetProvider);

    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1A1A1D),
      selectedItemColor: Colors.purpleAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        ref.watch(customFeetProvider.notifier).state = index;

        if (index == 0) {
          context.go("/home");
        } else if (index == 1) {
          context.go("/search");
        } else if (index == 2) {
          context.go("/myProfile");
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