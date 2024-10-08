import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maid_easy/on_boarding/add_address.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController _phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton.filled(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back),
          style: IconButton.styleFrom(
            backgroundColor: Colors.deepOrange.shade100
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: kToolbarHeight,),
          AutoSizeText("Registration",style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.bold
          ),),
          const Divider(height: 8,),
          AutoSizeText("Enter your phone number to verify \nyour account.",style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.6)
          )),
          const Divider(),
          IntlPhoneField(
            controller: _phone,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(22),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst,);
                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const AddAddress(),));
                  },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 22,horizontal: MediaQuery.sizeOf(context).width * 0.3)
                ),
                  child: const AutoSizeText("SEND"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
