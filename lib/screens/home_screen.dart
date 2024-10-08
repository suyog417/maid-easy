import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maid_easy/screens/appointment_info.dart';
import 'package:maid_easy/screens/bloc/database.dart';
import 'package:maid_easy/screens/categories.dart';
import 'package:maid_easy/screens/notifications.dart';
import 'package:maid_easy/screens/user_profile.dart';
import 'package:random_avatar/random_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navigationBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeScreenWidget(navBarIndex: navigationBarIndex,onTap: () {
        setState(() {
          navigationBarIndex = 1;
        });
      },),
      const Categories(),
      const Notifications(),
      const UserProfile()
    ];
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      // drawer: const Drawer(),
      body: screens[navigationBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_text), label: "Home"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: "Home"),
        ],
        onTap: (value) {
          setState(() {
            navigationBarIndex = value;
          });
        },
        currentIndex: navigationBarIndex,
        elevation: 2,
        selectedIconTheme: const IconThemeData(color: Colors.black),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedLabelStyle: const TextStyle(color: Colors.grey),
        showSelectedLabels: true,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;

  CustomAppBar({
    required this.child,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colors.orange,
      alignment: Alignment.center,
      child: child,
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  final void Function()? onTap;
  final int navBarIndex;
  const HomeScreenWidget({super.key, this.onTap, required this.navBarIndex});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  List<String> options = ["Cleaning", "Cooking", "Baby sitter", "Explore more"];
  List<IconData> icons = [
    FontAwesomeIcons.broom,
    FontAwesomeIcons.bowlFood,
    FontAwesomeIcons.baby,
    FontAwesomeIcons.arrowRight
  ];
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    context.read<DatabaseBloc>().connectDB();
    final textTheme = Theme.of(context).textTheme;
    context.read<DatabaseBloc>().getAllCollection("maids");
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<DatabaseBloc>().getAllCollection("");
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: RandomAvatar(user?.displayName ?? "suyog", height: 50, width: 50),
                ),
                const VerticalDivider(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      user?.displayName ?? "Suyog",
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(Hive.box("UserData").get("address") ?? "")
                  ],
                )
              ],
            ),
            const SizedBox(
              height: kToolbarHeight,
            ),
            AutoSizeText(
              "Looking for",
              style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  options.length,
                      (index) => Expanded(
                    child: InkWell(
                      onTap: widget.onTap,
                      child: Card(
                        // surfaceTintColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        color: Colors.lightBlueAccent.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icons.elementAt(index)),
                              const SizedBox(
                                height: 8,
                              ),
                              AutoSizeText(
                                options.elementAt(index),
                                style: textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            AutoSizeText("Maids around you",style: textTheme.titleMedium,),
            BlocBuilder<DatabaseBloc,DatabaseStates>(builder: (context, state) {
              if(state is DataLoadedState){
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:state.maids.length ,
                  itemBuilder: (context, index) {
                    List prefWork = state.maids.elementAt(index)['preferredWork'];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentInfo(
                              tag: "pfp$index",
                              phone: state.maids.elementAtOrNull(index)['phone'],
                              charges: state.maids.elementAtOrNull(index)['pricePerHour'],
                              fullName: state.maids.elementAtOrNull(index)['fullName'],
                              prefferedLocation: state.maids.elementAtOrNull(index)['preferredLocations'],
                              prefferedWork: state.maids.elementAtOrNull(index)['preferredWork'],
                              timeSLots: state.maids.elementAtOrNull(index)['timeSlots'],
                              workingDay: state.maids.elementAtOrNull(index)['workingDays'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        surfaceTintColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Hero(
                                tag: "pfp$index",
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(imageUrl: 'https://plus.unsplash.com/premium_photo-1681483534373-2d9250d3e1e9?q=80&w=2016&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                    height: MediaQuery.sizeOf(context).height * 0.15,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                  // Image.network(
                                  //   ,
                                  //   height: MediaQuery.sizeOf(context).height * 0.15,
                                  // ),
                                ),
                              ),
                              const VerticalDivider(),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(state.maids.elementAt(index)['fullName'],style: Theme.of(context).textTheme.titleLarge,),
                                            ...List.generate(prefWork.length, (index) => AutoSizeText(prefWork.elementAtOrNull(index),style: Theme.of(context).textTheme.titleSmall,wrapWords: true,softWrap: true,),),
                                          ],
                                        ),
                                        const Icon(Icons.shield)
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },);
              }
              return const SizedBox();
            },)
          ],
        ),
      ),
    );
  }
}
