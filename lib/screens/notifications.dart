import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
      ],
    );
  }
}
