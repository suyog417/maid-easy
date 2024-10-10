import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

abstract class OnBoardingStates{}

class OnBoardingInitialState extends OnBoardingStates{}
class MaidUserState extends OnBoardingStates {}
class CustomerUserState extends OnBoardingStates {}
class CustomerDataMissingState extends OnBoardingStates {}
class MaidDataMissingState extends OnBoardingStates {}
class OnBoardingLoadingState extends OnBoardingStates {}
class UserTypeNotSelectedState extends OnBoardingStates {}


class OnBoardingCubit extends Cubit<OnBoardingStates>{
  OnBoardingCubit() : super(OnBoardingInitialState()){
    navigateUser();
    Hive.box("UserData").listenable().addListener(() {
      navigateUser();
    },);
  }

  void navigateUser(){
    if(Hive.box("UserData").get("isMaid") == null){
      emit(UserTypeNotSelectedState());
    } else {
      if(Hive.box("UserData").get("isMaid") == true){
        if(Hive.box("UserData").get("address") == null){
          emit(MaidDataMissingState());
        } else {
          emit(MaidUserState());
        }
      } else {
        if(Hive.box("UserData").get("address") == null){
          emit(CustomerDataMissingState());
        } else {
          emit(CustomerUserState());
        }
      }
    }
  }
}