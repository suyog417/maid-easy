import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppoinmentBooked extends StatelessWidget {
  const AppoinmentBooked({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Icon(Icons.check_circle_outline,size: Theme.of(context).textTheme.displayLarge!.fontSize! * 2,),
            AutoSizeText("Your request has been sent.",textAlign: TextAlign.center,style: Theme.of(context).textTheme.displaySmall,),
            const Spacer(),
            FilledButton(onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst,);
            }, child: const Text("Explore more"))
          ],
        ),
      ),
    );
  }
}
