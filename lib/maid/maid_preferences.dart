import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maid_easy/maid/home_screen_maid.dart';
import 'package:maid_easy/on_boarding/bloc/on_boarding_cubit.dart';
import 'package:maid_easy/utils/constants.dart';

class MaidPreferences extends StatefulWidget {
  const MaidPreferences({super.key});

  @override
  State<MaidPreferences> createState() => _MaidPreferencesState();
}

class _MaidPreferencesState extends State<MaidPreferences> {
  List<String> selected = [];
  List<String> preferredTime = [];
  String selectedCategory = "Cooking Services";
  List<String> categories = ["Cooking Services",
    "Cleaning Services",
    "Babysitting/Nanny Services",
    "Care taking/Elder Care Services","Pet Care Services","Gardening Services"];
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
            Divider(color: Colors.transparent,),
            DecoratedBox(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide())
              ),
              child: DropdownButtonHideUnderline(child: DropdownButton(
                items: List.generate(categories.length, (index) => DropdownMenuItem(child: Text(categories.elementAt(index)),value: categories.elementAt(index),),),
                value: selectedCategory,
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
                ChoiceChip(label: const Text("9:00 AM"), selected: preferredTime.contains("9:00 AM"),onSelected: (value) {
                  setState(() {
                    if(value){
                      preferredTime.add("9:00 AM");
                    } else {
                      preferredTime.remove("9:00 AM");
                    }
                  });
                },),
                ChoiceChip(label: const Text("12:00 PM"), selected: preferredTime.contains("12:00 PM"),onSelected: (value) {
                    setState(() {
                      if(value){
                        preferredTime.add("12:00 PM");
                      } else {
                        preferredTime.remove("12:00 PM");
                      }
                    });
                },),
                ChoiceChip(label: const Text("4:00 PM"), selected: preferredTime.contains("4:00 PM"),onSelected: (value) {
                    setState(() {
                      if(value){
                        preferredTime.add("4:00 PM");
                      } else {
                        preferredTime.remove("4:00 PM");
                      }
                    });
                },),
                ChoiceChip(label: const Text("7:00 PM"), selected: preferredTime.contains("7:00 PM"),onSelected: (value) {
                    setState(() {
                      if(value){
                        preferredTime.add("7:00 PM");
                      } else {
                        preferredTime.remove("7:00 PM");
                      }
                    });
                },),
              ],
            ),
            _registerTextInputField("Charges", "Charges", (value) => null, TextInputType.number),
            const Divider(color: Colors.transparent,),
            FilledButton(onPressed: () {

              Hive.box("UserData").putAll({
                "address": "Pune",
                "preferredTime" : preferredTime,
                "preferredLocations" : selected,
                "category" : selectedCategory
              }).whenComplete(() {
                Navigator.popUntil(context, (route) => route.isFirst,);
                Navigator.push(context, CupertinoPageRoute(builder: (context) => const HomeScreenMaid(),));
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
