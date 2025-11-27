import 'package:flutter/material.dart';
import 'package:game_community/Widgets/list_view.dart';

class Stream_Builder extends StatelessWidget
{
  const Stream_Builder({super.key});

  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder<dynamic>(
        stream: Stream.empty(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
        {
          if (snapshot.hasError)
          {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null)
          {
            return Center(child: Text("Don`t have a community? Search one right now"));
          }

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 6),
              padding: EdgeInsets.all(12),
              shrinkWrap: true,
              clipBehavior: Clip.none,

              itemCount: 4,

              itemBuilder: (BuildContext context, int can)
              {
                return Column(
                  children: [
                    TextField(textAlign: TextAlign.center, textInputAction: TextInputAction.search,),
                  ]
                );
              }
          );
        }

    );
  }
}
