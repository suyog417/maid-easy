import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenMaid extends StatefulWidget {
  const HomeScreenMaid({super.key});

  @override
  State<HomeScreenMaid> createState() => _HomeScreenMaidState();
}

class _HomeScreenMaidState extends State<HomeScreenMaid> {
  int selectedNavbarIndex = 0;
  List<Widget> _screens = [
    MaidHomeScreenWidget(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(selectedNavbarIndex),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble),label: "Alerts"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.person))
      ],
        currentIndex: selectedNavbarIndex,
        onTap: (value) {
          setState(() {
            selectedNavbarIndex = value;
          });
        },
      ),
    );
  }
}

class MaidHomeScreenWidget extends StatelessWidget {
  const MaidHomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Text("kjsdnklsdnvls")
      ],
    );
  }
}

