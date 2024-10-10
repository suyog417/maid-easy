import 'package:flutter/material.dart';

class MaidNotifications extends StatelessWidget {
  const MaidNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ListView(
      padding: EdgeInsets.all(16),
      children: [
        SizedBox(
          height: kToolbarHeight,
          child: Text("Messages",style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold
          ),),
        )
      ],
    ));
  }
}
