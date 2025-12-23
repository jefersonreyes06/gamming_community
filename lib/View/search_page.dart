import 'package:flutter/material.dart';
import 'package:game_community/Widgets/app_bar.dart';
import 'package:game_community/Widgets/custom_search.dart';
import 'package:game_community/Widgets/custom_feet.dart';
import 'package:game_community/Widgets/stream_builder.dart';

class SearchPage extends StatelessWidget
{

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: Encabezado(backgroundColor: Colors.black87, title: "Search"),

      body: Container(
        decoration: BoxDecoration(color: Colors.black87),
        child: Column(
          children: [
            CustomSearch(),
            Stream_Builder()
          ],
        ),

      ),

      bottomNavigationBar: CustomFeet(),
    );
  }
}