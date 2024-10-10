import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maid_easy/maid/maid_notifications.dart';
import 'package:maid_easy/maid/maid_profile.dart';
import 'package:maid_easy/api/database.dart';

class HomeScreenMaid extends StatefulWidget {
  const HomeScreenMaid({super.key});

  @override
  State<HomeScreenMaid> createState() => _HomeScreenMaidState();
}

class _HomeScreenMaidState extends State<HomeScreenMaid> {
  int selectedNavbarIndex = 0;
  final List<Widget> _screens = const [
    MaidHomeScreenWidget(),
    MaidProfile()
  ];
  @override
  Widget build(BuildContext context) {
    context.read<DatabaseBloc>().getMaidCollection("");
    return Scaffold(
      body: _screens.elementAt(selectedNavbarIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: "profile")
        ],
        currentIndex: selectedNavbarIndex,
        onTap: (value) {
          setState(() {
            selectedNavbarIndex = value;
          });
        },
      ),
    );
  }
}

class MaidHomeScreenWidget extends StatelessWidget {
  const MaidHomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<DatabaseBloc>().getMaidCollection("");
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Text(
                "Available Jobs",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            // BlocBuilder<DatabaseBloc, DatabaseStates>(
            //   builder: (context, state) {
            //     if(state is DataLoadedState){
            //       return ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: state.maids.length,
            //         itemBuilder: (context, index) {
            //           return ListTile(
            //             title: Text(state.maids.elementAt(index)['fullName']),
            //           );
            //         },
            //       );
            //     }
            //     return const Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   },
            // )
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
                                  FilledButton(onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AiBarcodeScanner(
                                      onDetect: (BarcodeCapture capture) {
                                        final String? scannedValue =
                                            capture.barcodes.first.rawValue;
                                        debugPrint("Barcode scanned: $scannedValue");
                                        Navigator.pop(context);
                                      },
                                      successColor: Colors.green,
                                      hideGalleryIcon: true,
                                      onDispose: () {
                                        /// This is called when the barcode scanner is disposed.
                                        /// You can write your own logic here.
                                        debugPrint("Barcode scanner disposed!");
                                      },
                                      hideGalleryButton: false,
                                      controller: MobileScannerController(
                                        detectionSpeed: DetectionSpeed.noDuplicates,
                                      ),
                                    ),));
                                  },
                                    style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.all(8)
                                    ),
                                    child: const Text("Mark as complete"),
                                  ),
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
        ),
      ),
    );
  }
}
