import 'package:flutter/material.dart';
import 'package:game_community/Widgets/custom_feet.dart';
import 'package:game_community/Widgets/custom_search.dart';
import 'package:game_community/Widgets/stream_builder_joined_communities.dart';
import 'package:game_community/Widgets/community_card.dart';
import 'package:game_community/Widgets/post_card.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:game_community/Widgets/text_field.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  double _currentPage = 0;

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
        width: 230,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

            children:
            [
              SizedBox(height: 35,),
              Text("Communities", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              CustomTextField(hintText: "Search a community", trailingIcon: Icon(Icons.search),
                  fontSize: 15, height: 25, yPadding: 0, xPadding: 17, borderRadius: 50,),

              /*
              CustomSearch(
                  backgroundColor: Color.fromARGB(200, 34, 33, 33), title: "",
                  hintText: "Community", trailingIcon: Icon(Icons.search),
                  height: 36, fontSize: 15.5, textColor: Colors.white,
                widthTextField: 180
              ),*/
              Divider(),
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
                  setState(() => _currentPage = index.toDouble());
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

      bottomNavigationBar: CustomFeet(),
    );
  }
}
