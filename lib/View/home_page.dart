import 'package:flutter/material.dart';
import 'package:game_community/Widgets/stream_builder.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Game Community", style: TextStyle(color: Colors.white),),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,

        children:
        [
          Container(
            color: Colors.white30,
            padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 10),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text("data"),
                SizedBox(width: 20),

                Container(
                  height: 25,
                  width: 150,

                  child: TextField(
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.bottom,


                    decoration: InputDecoration(
                      hintText: "Escribe algo...",
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      suffixIcon: Icon(Icons.search)
                    ),
                  ),
                ),
              ]
            )
          ),
          SizedBox(height: 100,),

          Stream_Builder()
        ]
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white30,
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
            context.go("/login");
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Buscar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      )
    );
  }
}
