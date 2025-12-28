import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_community/Provider/communities_provider.dart';
import 'package:game_community/Widgets/app_bar.dart';
import 'package:game_community/Widgets/custom_feet.dart';
import 'package:game_community/Widgets/stream_builder_joined_communities.dart';
import 'package:game_community/Widgets/community_card.dart';
import 'package:game_community/Widgets/post_card.dart';
import 'package:dots_indicator/dots_indicator.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final communities = [
    'FPS',
    'RPG',
    'MOBA',
    'Indie',
    'Retro',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'GameHub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.message_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          })
        ],
      ),

      drawer: Drawer(
        width: 220,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,

            children:
            [
              //DrawerHeader(child: Text('Communities')),
              SizedBox(height: 10,),
              Container(
                  color: const Color(0xFF323237),
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
                          color: const Color(0xFF323237),

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
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🎮 COMMUNITY CAROUSEL
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: _pageController,
                itemCount: communities.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);//.toDouble());
                },
                itemBuilder: (context, index) {
                  return CommunityCard(
                    title: communities[index],
                  );
                },
              ),
            ),

            /// 🔵 DOTS INDICATOR
            Center(
              child: DotsIndicator(
                dotsCount: communities.length,
                position: _currentPage,
                decorator: DotsDecorator(
                  activeColor: Colors.purpleAccent,
                  color: Colors.grey.shade700,
                  size: const Size.square(8),
                  activeSize: const Size(20, 8),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📰 POSTS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Latest Posts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const PostCard();
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1D),
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  /*
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
  }*/
}
