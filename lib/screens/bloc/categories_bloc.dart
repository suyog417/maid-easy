import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoriesStates {}

class CategoriesInitialState extends CategoriesStates{}

class CategoriesLoadedState extends CategoriesStates{
  final List<String> categories;
  CategoriesLoadedState(this.categories);
}

class CategoriesCubit extends Cubit<CategoriesStates>{
  CategoriesCubit() : super(CategoriesInitialState()){
    setData();
  }

  List<String> categories = ["Cooking Services",
    "Cleaning Services",
    "Babysitting/Nanny Services",
    "Care taking/Elder Care Services","Pet Care Services","Gardening Services"];

  void setData() => emit(CategoriesLoadedState(categories));

  void search(String query) {
    emit(CategoriesLoadedState(categories.where((element) => element.toLowerCase().contains(query.toLowerCase()),).toList()));
  }
}