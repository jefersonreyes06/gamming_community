import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomFeet extends StatefulWidget
{
  const CustomFeet({super.key});

  @override
  State<CustomFeet> createState() => CustomFeetState();
}

class CustomFeetState extends State<CustomFeet>
{
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context)
  {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

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
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: "Communities",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Perfil",
        ),
      ],
    );
  }
}