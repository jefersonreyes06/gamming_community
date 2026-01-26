import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_community/core/shared/widgets/app_bar.dart';
import 'package:game_community/core/shared/widgets/custom_feet.dart';
import 'package:game_community/features/communities/widgets/stream_builder.dart';
import '../../../core/shared/widgets/text_field.dart';
import '../state/communities_provider.dart';
import '../widgets/custom_card.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();

    return Scaffold(
      appBar: Encabezado(backgroundColor: Colors.black87, title: "COMMUNITIES"),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        decoration: BoxDecoration(color: Colors.black87),
        child: Column(
          children: [
            Divider(),
            SizedBox(
              width: double.infinity,
              child: CustomTextField(
                hintText: "Search a community",
                trailingIcon: IconButton(icon: Icon(Icons.search),
                  onPressed: () async {
                    final searchProvider =  ref.watch(searchCommunitiesProvider(searchController.text.toString())).value;

                    // I will show a result list
                    //print(searchProvider);
                  }
                ),
                fontSize: 16, height: 28, yPadding: 0, xPadding: 17, borderRadius: 24, searchController: searchController,
              ),
            ),
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () async {
                  //print(searchController.text);
                  final searchProvider = await ref.watch(searchCommunitiesProvider(searchController.text.toString()));
                  //print(searchProvider.value!.name);
                  /*searchProvider.when(
                      data: (result) => ListView.builder(
                        itemCount: result.length,
                          itemBuilder: (BuildContext context, int i) {
                          print(result.length);
                          print(result.toString());
                            return ListTile(
                              title: Text(result[i].name),
                              subtitle: Text(result[i].membersCount.toString()),
                            );
                          }
                      ),
                      error: (e, _) => Text(e.toString()),
                      loading: () => CircularProgressIndicator()
                  );*/
                },
                    icon: Icon(Icons.search, size: 30,))
              ]
            ),*/
            Divider(),
            Expanded(child: Stream_Builder()),
          ],
        ),
      ),

      bottomNavigationBar: CustomFeet(),
    );
  }
}
