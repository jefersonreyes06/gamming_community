import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/Widgets/app_bar.dart';
import 'package:game_community/Widgets/custom_feet.dart';
import 'package:game_community/Widgets/stream_builder_joined_communities.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
  CommunitiesProvider communitiesProvider = CommunitiesProvider();
  FirebaseAuth user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      //backgroundColor: Colors.white70,
      appBar: Encabezado(backgroundColor: Colors.deepPurpleAccent, title: "Gaming Community",),
      drawer: Drawer(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,

              children:
              [
                //DrawerHeader(child: Text('Communities')),
                SizedBox(height: 10,),
                Container(
                    color: Colors.white70,
                    padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 10),

                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text("Groups"),
                          SizedBox(width: 20),

                          Container(
                            height: 20,
                            width: 100,

                            child: TextField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,

                              decoration: InputDecoration(
                                  hintText: "Escribe algo...",
                                  border: OutlineInputBorder(),
                                  //alignLabelWithHint: true,
                                  suffixIcon: Icon(Icons.search)
                              ),
                            ),
                          ),
                        ]
                    )
                ),

                Text("Communities", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Expanded(child: StreamBuilderJoined())
              ]
        ),
        width: 220,
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),

        child: Center(
          child: Text("Let's start to chat in communities where you along!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add),),
      bottomNavigationBar: CustomFeet()
    );
  }
}
