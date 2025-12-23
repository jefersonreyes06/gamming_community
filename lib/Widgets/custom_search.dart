import 'package:flutter/material.dart';

class CustomSearch extends StatefulWidget
{
  const CustomSearch({super.key});

  @override
  State<CustomSearch> createState() => CustomSearchState();
}

class CustomSearchState extends State<CustomSearch>
{
  @override
  Widget build (BuildContext context)
  {
    return Container(
        color: Colors.deepPurpleAccent,
        padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 10),

        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text("Groups"),
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
    );
  }
}