import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maid_easy/on_boarding/bloc/sign_in_bloc.dart';
import 'package:random_avatar/random_avatar.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.shade100
            ),
            currentAccountPicture: CircleAvatar(
              child: RandomAvatar(user?.displayName ?? "suyog"),
            ),
              accountName: Text(user!.displayName ?? "suyog"), accountEmail: Text(user.email ?? "suyog")),
          ListTile(
            title: const Text("Log Out"),
            onTap: () {
              Hive.box("UserData").clear();
              context.read<SignInCubit>().logOut();
            },
            leading: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
