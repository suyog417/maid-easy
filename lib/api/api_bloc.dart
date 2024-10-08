import 'package:flutter_bloc/flutter_bloc.dart';

abstract class APIStates {}

class APIInitialState extends APIStates{}

class APIFetchingState extends APIStates{}

class APIRequestSuccessfulState extends APIStates{}

class APIBloc extends Cubit<APIStates>{
  APIBloc() : super(APIInitialState());

}