import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maid_easy/screens/bloc/database.dart';
import 'package:maid_easy/screens/home_screen.dart';

class UserTypeSelection extends StatelessWidget {
  const UserTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AutoSizeText("Why you are using this app ?",style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold
            ),),
            const Divider(color: Colors.transparent,),
            OutlinedButton(onPressed: () {
              context.read<DatabaseBloc>().connectDB();
              Hive.box("UserData").put("isMaid",true).whenComplete(() {
                Navigator.popUntil(context, (route) => route.isFirst,);
                Navigator.push(context, CupertinoPageRoute(builder: (context) => const HomeScreen(),));
              },);
            },style: OutlinedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ), child: const AutoSizeText("I want a job"),),
            const Divider(color: Colors.transparent,),
            OutlinedButton(onPressed: () {
              context.read<DatabaseBloc>().connectDB();
              Hive.box("UserData").put("isMaid",false).whenComplete(() {
                Navigator.popUntil(context, (route) => route.isFirst,);
                Navigator.push(context, CupertinoPageRoute(builder: (context) => const HomeScreen(),));
              },);
            },style: OutlinedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ), child: const AutoSizeText("I want a maid"),)
          ],
        ),
      )
    );
  }
}
