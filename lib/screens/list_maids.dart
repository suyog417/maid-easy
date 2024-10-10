import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maid_easy/api/database.dart';

class ListMaids extends StatelessWidget {
  final List maids;

  const ListMaids({super.key, required this.maids});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<DatabaseBloc, DatabaseStates>(
        builder: (context, state) {
          if(state is DataLoadedState){
            // return ElevatedButton(onPressed: () {
            //   print(maids.first['maid_id']);
            //   print(state.maids.where((element) => element["_id"].oid == maids.first['maid_id'],).toList());
            // }, child: Text("data"));
            List list = state.maids.where((element) => element["_id"].oid == maids.first['maid_id'],).toList();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
              return Card(
                surfaceTintColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(state.maids.elementAt(index)['fullName'],style: Theme.of(context).textTheme.titleLarge,),
                                    // ...List.generate(prefWork.length, (index) => AutoSizeText(prefWork.elementAtOrNull(index),style: Theme.of(context).textTheme.titleSmall,wrapWords: true,softWrap: true,),),
                                  ],
                                ),
                                const Icon(Icons.shield)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },);
          }
          return ElevatedButton(onPressed: () {
            print(state);
          }, child: Text("data"));
        },
      ),
    );
  }
}
