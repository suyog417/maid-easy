import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maid_easy/utils/constants.dart';

class MaidPreferences extends StatefulWidget {
  const MaidPreferences({super.key});

  @override
  State<MaidPreferences> createState() => _MaidPreferencesState();
}

class _MaidPreferencesState extends State<MaidPreferences> {
  List<String> selected = [];
  List<String> preferredTime = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
             SizedBox(
              height: kToolbarHeight,
              child: Text("Preferences",style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold
              ),),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide())
              ),
              child: DropdownButtonHideUnderline(child: DropdownButton(
                items: [
                  const DropdownMenuItem(child: Text("Cleaning"),value: "Cleaning",),
                  const DropdownMenuItem(child: Text("Cooking"),value: "Cooking",)
                ],
                value: "Cooking",
                onChanged: (value) {
        
                },)),
            ),
            Text("Preferred Locations",style: Theme.of(context).textTheme.titleMedium,),
            Wrap(
              spacing: 6,
              children: List.generate(
                localities.length,
                    (index) => ChoiceChip.elevated(
                    showCheckmark: true,
                    label: Text(localities.elementAt(index)),
                    onSelected: (value) {
                      setState(() {
                        if(value) {
                          selected.add(localities.elementAt(index));
                        }else {
                          selected.remove(localities.elementAt(index));
                        }
                      });
                    },
                    selected: selected.contains(localities.elementAt(index))),
              ),
            ),
            const Divider(color: Colors.transparent,),
            const Text("Preferred time"),
            Wrap(
              children: [
                ChoiceChip(label: const Text("9:00 AM"), selected: preferredTime.contains("9:00 AM")),
                ChoiceChip(label: const Text("12:00 AM"), selected: preferredTime.contains("12:00 AM")),
                ChoiceChip(label: const Text("4:00 PM"), selected: preferredTime.contains("4:00 PM")),
                ChoiceChip(label: const Text("7:00 PM"), selected: preferredTime.contains("7:00 PM")),
              ],
            ),
            _registerTextInputField("Charges", "Charges", (value) => null, TextInputType.number),
            const Divider(color: Colors.transparent,),
            FilledButton(onPressed: () {
              Hive.box("UserData").put("address", "Pune").whenComplete(() {
                print("done");
              },);
            }, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
  Widget _registerTextInputField(String hint,String label,String? Function(String? value) validator,TextInputType keyboardType){
    return TextFormField(
      decoration: InputDecoration(
          hintText: hint,
          label: Text(label)
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
