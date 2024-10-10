import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maid_easy/screens/home_screen.dart';
import 'package:maid_easy/utils/constants.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _address = TextEditingController();
  // late String street;
  // late String locality;
  // late String subLocality;
  // late String postalCode;
  // late String adminArea;
  List<String> selected = [];

  @override
  void dispose() {
    // TODO: implement dispose
    _address.dispose();
    super.dispose();
  }

  String _selectedItem = "Katraj";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText("Add new address"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton(
                items: List.generate(
                  localities.length,
                  (index) {
                    return DropdownMenuItem(
                      value: localities.elementAt(index),
                      child: Text(localities.elementAt(index)),
                    );
                  },
                ),
                value: _selectedItem,
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value!;
                  });
                },
              ),
            )
            // TextFormField(
            //   controller: _address,
            //   decoration: InputDecoration(
            //       border: const UnderlineInputBorder(),
            //       enabledBorder: const UnderlineInputBorder(),
            //     hintText: "Address",
            //     label: const AutoSizeText("Address"),
            //     suffix: IconButton(icon: const Icon(Icons.my_location,),onPressed: () async {
            //       if(await loc.Location().hasPermission() == loc.PermissionStatus.denied){
            //         loc.Location().requestPermission();
            //       }
            //       if(await loc.Location().hasPermission() == loc.PermissionStatus.granted){
            //         // AppSettings.openAppSettings(type: AppSettingsType.location)
            //         if( await loc.Location().serviceEnabled()){
            //           loc.LocationData _loc = await loc.Location().getLocation();
            //           List<Placemark> placeMarks = await placemarkFromCoordinates(_loc.latitude!.toDouble(),_loc.longitude!.toDouble());
            //           Placemark curr = placeMarks.first;
            //           setState(() {
            //             street = curr.street!;
            //             subLocality = curr.subLocality!;
            //             locality = curr.locality!;
            //             adminArea = curr.administrativeArea!;
            //             postalCode = curr.postalCode!;
            //             _address.text = "${curr.street},${curr.subLocality},${curr.locality},${curr.administrativeArea},${curr.postalCode}";
            //           });
            //         }
            //         else{
            //           loc.Location().requestService();
            //         }
            //       }
            //     },)
            //   ),
            // ),
            // Wrap(
            //   spacing: 6,
            //   children: List.generate(
            //     localities.length,
            //     (index) => ChoiceChip.elevated(
            //       showCheckmark: true,
            //         label: Text(localities.elementAt(index)),
            //         onSelected: (value) {
            //           setState(() {
            //             if(value) {
            //               selected.add(localities.elementAt(index));
            //             }else {
            //               selected.remove(localities.elementAt(index));
            //             }
            //           });
            //         },
            //         selected: selected.contains(localities.elementAt(index))),
            //   ),
            // )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22),
            child: FilledButton(
              onPressed: () {
                final box = Hive.box("UserData");
                box.putAll({
                  // "address": _address.text.trim(),
                  "locality": _selectedItem,
                  // "city": locality,
                  // "state": adminArea,
                  // "street": street,
                  // "postalCode": postalCode,
                });
                box.put("address", _address.text.trim()).whenComplete(
                  () {
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  },
                );
                // Navigator.push(context, CupertinoPageRoute(builder: (context) => const HomeScreen(),));
              },
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
              child: const Text("SAVE"),
            ),
          )),
    );
  }
}
