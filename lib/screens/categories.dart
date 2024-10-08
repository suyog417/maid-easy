import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maid_easy/screens/bloc/categories_bloc.dart';
import 'package:maid_easy/screens/list_maids.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> imageURL = [
      "https://images.pexels.com/photos/175753/pexels-photo-175753.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/713297/pexels-photo-713297.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/7282227/pexels-photo-7282227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://www.homedoc.in/wp-content/uploads/2019/09/elderly-care-in-Gurgaon.jpg",
      "https://images.pexels.com/photos/7474089/pexels-photo-7474089.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://5.imimg.com/data5/SELLER/Default/2021/5/VQ/KP/DC/29076740/home-gardening-services.jpg"
    ];
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: MediaQuery.paddingOf(context).top),
      children: [
        SizedBox(
          height: kToolbarHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText("Categories",style: Theme.of(context).textTheme.titleLarge,)
            ],
          ),
        ),
        CupertinoSearchTextField(
          padding: const EdgeInsets.all(16),
          onChanged: (value) {
            context.read<CategoriesCubit>().search(value);
          },
        ),
        BlocBuilder<CategoriesCubit,CategoriesStates>(builder: (context, state) {
          if(state is CategoriesLoadedState){
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.categories.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ListMaids(filter: state.categories.elementAt(index)),));
                },
                child: Card(
                  color: Colors.lightBlueAccent.shade100,
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.25,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: imageURL.elementAt(index),
                              width: MediaQuery.sizeOf(context).width,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                                gradient: LinearGradient(colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent
                                ],
                                    stops: const [0.3,1],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter
                                )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0,top: 24,left: 16,bottom: 16),
                              child: Row(
                                  children: [
                                    Text(state.categories.elementAt(index),style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.surface
                                    ),),
                                  ],
                                ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ),
              );
            },);
          }
          return const SizedBox();
        },)
      ],
    );
  }
}
