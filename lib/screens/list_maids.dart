import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maid_easy/screens/bloc/database.dart';

class ListMaids extends StatelessWidget {
  final String filter;
  const ListMaids({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<DatabaseBloc,DatabaseStates>(builder: (context, state) {
        if(state is DataLoadedState){
          List maids = state.maids.where((element) => element['preferredWork'].contains(filter),).toList();
          return ListView.builder(
            itemCount: maids.length,
            itemBuilder: (context, index) {
              List prefWork = state.maids.elementAt(index)['preferredWork'];
            return InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AppointmentInfo(
                //       tag: "pfp$index",
                //       phone: state.maids.elementAtOrNull(index)['phone'],
                //       charges: state.maids.elementAtOrNull(index)['pricePerHour'],
                //       fullName: state.maids.elementAtOrNull(index)['fullName'],
                //       prefferedLocation: state.maids.elementAtOrNull(index)['preferredLocations'],
                //       prefferedWork: state.maids.elementAtOrNull(index)['preferredWork'],
                //       timeSLots: state.maids.elementAtOrNull(index)['timeSlots'],
                //       workingDay: state.maids.elementAtOrNull(index)['workingDays'],
                //     ),
                //   ),
                // );
              },
              child: Card(
                surfaceTintColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Hero(
                        tag: "pfp$index",
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(imageUrl: 'https://plus.unsplash.com/premium_photo-1681483534373-2d9250d3e1e9?q=80&w=2016&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                              height: MediaQuery.sizeOf(context).height * 0.15,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          // Image.network(
                          //   ,
                          //   height: MediaQuery.sizeOf(context).height * 0.15,
                          // ),
                        ),
                      ),
                      const VerticalDivider(),
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
                                    AutoSizeText(maids.elementAt(index)['fullName'],style: Theme.of(context).textTheme.titleLarge,),
                                    ...List.generate(prefWork.length, (index) => AutoSizeText(prefWork.elementAtOrNull(index),style: Theme.of(context).textTheme.titleSmall,wrapWords: true,softWrap: true,),),
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
              ),
            );
          },);
        }
        return Container();
      },),
    );
  }
}
