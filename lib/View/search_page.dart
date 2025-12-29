import 'package:flutter/material.dart';
import 'package:game_community/Widgets/app_bar.dart';
import 'package:game_community/Widgets/custom_search.dart';
import 'package:game_community/Widgets/custom_feet.dart';
import 'package:game_community/Widgets/stream_builder.dart';
import 'package:game_community/Provider/communities_provider.dart';

class SearchPage extends StatelessWidget {
  CommunitiesProvider communitiesProvider = CommunitiesProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Encabezado(backgroundColor: Colors.black87, title: "COMMUNITIES"),

      body: Container(
        decoration: BoxDecoration(color: Colors.black87),
        child: Column(
          children: [
            Divider(),
            SizedBox(
              width: double.infinity,
              child: CustomSearch(
                height: 42,
                fontSize: 18,
                textColor: Colors.white,
                backgroundColor: Colors.black12,
                title: "",
                hintText: "Buscar comunidades",
                trailingIcon: const Icon(Icons.search),
              ),
            ),
            Divider(),
            Expanded(child: Stream_Builder()),
          ],
        ),
      ),

      bottomNavigationBar: CustomFeet(),
    );
  }
}
