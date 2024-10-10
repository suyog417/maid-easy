import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maid_easy/api/database.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: kToolbarHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText("Notifications",style: Theme.of(context).textTheme.titleLarge,)
            ],
          ),
        ),
        BlocBuilder<DatabaseBloc,DatabaseStates>(
          builder: (context, state) {
          if(state is DataLoadedState){
            Map contracts = state.contracts.where((element) => "67063665e011d5e56ec7f7fe" == element['customerId'],).toList().asMap();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: contracts.length,
              itemBuilder: (context, index) {
                Map maid = state.maids.where((element) => element['_id'].oid == state.contracts.elementAt(index)['maidId'],).toList().asMap();
                // print(contracts);
                // print(maid);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(maid.values.elementAtOrNull(0)['fullName'],style: Theme.of(context).textTheme.titleLarge,),
                          Text(contracts.values.elementAt(index)['status']),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AspectRatio(aspectRatio: 1,child: QrImageView(data: contracts.values.elementAt(index)['jobId']),),
                          FilledButton(onPressed: () {},
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(8)
                            ),
                              child: const Text("Cancel"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },);
          }
          return const Center(child: CircularProgressIndicator());
        },)
      ],
    );
  }
}
