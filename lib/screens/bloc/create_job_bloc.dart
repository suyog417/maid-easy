import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maid_easy/api/api.dart';

abstract class CreateJobStates {}

class JobCreationInitialState extends CreateJobStates {}

class JobCreatedSuccessfullyState extends CreateJobStates {
  final String id;
  JobCreatedSuccessfullyState(this.id);
}

class JobCreationFailedState extends CreateJobStates {}

class RecommsLoadedState extends CreateJobStates {
  final Response data;
  RecommsLoadedState(this.data);
}

class JobCreationInProgress extends CreateJobStates {}

class CreateJobBloc extends Cubit<CreateJobStates> {
  CreateJobBloc() : super(JobCreationInitialState());

  APIHandler apiHandler = APIHandler();

  void createJob(String userId, dynamic data) async {
    emit(JobCreationInProgress());
    try {
      Response response = await apiHandler.createJob(userId, data);
      // print(response.data['message']["job"]['_id'].runtimeType);
      emit(JobCreatedSuccessfullyState(await response.data['message']["job"]['_id']));
      emit(JobCreationInitialState());
    } catch (e) {
      emit(JobCreationFailedState());
      emit(JobCreationInitialState());
    }
  }

  void getRecommendations(String jobId) async {
    try {
      Response response = await apiHandler.getRecomms(jobId);
      // print(response.data.runtimeType);
      emit(RecommsLoadedState(response));
      emit(JobCreationInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
