import 'package:flutter/material.dart';
import 'package:game_community/core/shared/widgets/custom_feet.dart';
import 'package:game_community/core/shared/widgets/custom_text_interactive.dart';
import 'package:game_community/features/home/widgets/stream_builder_joined_communities.dart';
import 'package:game_community/features/home/widgets/community_card.dart';
import 'package:game_community/features/home/widgets/post_card.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:game_community/core/shared/widgets/text_field.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
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
        width: 290,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,

            children:
            [
              SizedBox(height: 35,),
              Text("Communities", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              CustomTextField(hintText: "Search a community", trailingIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  fontSize: 15, height: 25, yPadding: 0, xPadding: 17, borderRadius: 50, searchController: _searchController,
              ),
              Divider(),
              Row(
                spacing: 10,
                children: [
                  SizedBox(width: 10,),
                  CustomTextInteractive(borderColor: Colors.blue, isCenter: false, text: "Chats", color: Colors.white, fontSize: 14,
                      fontWeight: 200, onTap: () {}, width: 40, height: 2.3),
                  CustomTextInteractive(borderColor: Colors.blue, isCenter: false, text: "Communities", color: Colors.white, fontSize: 14,
                      fontWeight: 200, onTap: () {}, width: 90, height: 2.3),
                ],
              ),
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
