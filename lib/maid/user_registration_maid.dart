import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maid_easy/maid/maid_preferences.dart';
import 'package:maid_easy/utils/constants.dart';

class UserRegistrationMaid extends StatefulWidget {
  const UserRegistrationMaid({super.key});

  @override
  State<UserRegistrationMaid> createState() => _UserRegistrationMaidState();
}

class _UserRegistrationMaidState extends State<UserRegistrationMaid> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController(text: "+91 ");
  final TextEditingController _aadhar = TextEditingController();
  final pccVerificationKey = GlobalKey<FormState>();
  bool isPCCVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Text("Register",style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold
              ),),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Name",
                label: Text("Name")
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "Name cannot be empty";
                }
                return null;
              },
              keyboardType: TextInputType.name,
            ),
            const Divider(color: Colors.transparent,),
            _registerTextInputField("age", "Age", (value) => null, TextInputType.number),
            const Divider(color: Colors.transparent,),
            _registerTextInputField("Address", "Address", (value) => null, TextInputType.number),
            const Divider(color: Colors.transparent,),
            _registerTextInputField("Mobile Number", "Mobile Number", (value) => null, TextInputType.number),
            const Divider(color: Colors.transparent,),
            _registerTextInputField("Aadhar Number", "Aadhar Number", (value) => null, TextInputType.number),
            const Divider(color: Colors.transparent,),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                showModalBottomSheet(
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  context: context, builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: pccVerificationKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PCC Verification",textAlign: TextAlign.start,style: Theme.of(context).textTheme.titleLarge,),
                          _registerTextInputField("Mobile", "Mobile Number", (value) {
                            if(value == null || value.isEmpty){
                              return "Enter valid mobile number";
                            }
                            return null;
                          }, TextInputType.phone),
                          const Divider(color: Colors.transparent,),
                          _registerTextInputField("Application id", "Application id", (value) {
                            if(value == null || value.isEmpty){
                              return "Enter valid application ID";
                            }
                            return null;
                          }, TextInputType.number),
                          const Divider(color: Colors.transparent,),
                          _registerTextInputField("Police Station Name", "Police Station Name", (value) {
                            if(value == null || value.isEmpty){
                              return "Enter valid details";
                            }
                            return null;
                          }, TextInputType.text),
                          const Divider(color: Colors.transparent,),
                          FilledButton(onPressed: () {
                            pccVerificationKey.currentState!.validate();
                            setState(() {
                              isPCCVerified = !isPCCVerified;
                            });
                            Navigator.pop(context);
                          },style: FilledButton.styleFrom(
                            fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width)
                          ), child: const Text("Verify"),),
                          SizedBox(
                            height: MediaQuery.viewInsetsOf(context).bottom,
                          )
                        ],
                      ),
                    ),
                  );
                },);
              },
              title: const Text("is PCC verified?"),
              leading: Checkbox(value: isPCCVerified, onChanged: (value) {},),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton(onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => MaidPreferences(),));
        },
          style: FilledButton.styleFrom(
            fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width)
        ), child: const Text("Next"),
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


