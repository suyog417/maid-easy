import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OnBoardingStates{}

class OnBoardingInitialState extends OnBoardingStates{}

class OnBoardingFailedState extends OnBoardingStates{}

class OnBoardingInProcessState extends OnBoardingStates{}


class OnBoardingCubit extends Cubit<OnBoardingStates>{
  OnBoardingCubit() : super(OnBoardingInitialState());

  void getUserData() {

  }
}