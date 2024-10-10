import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final Dio _dio = Dio();
  API() {
    _dio.options.baseUrl = "https://maid-easy-backend.vercel.app/api/v1";
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequests => _dio;
}


class APIHandler{

  APIHandler(){
    recommendations.options.baseUrl = "https://maideasy-flask-app.onrender.com";
    recommendations.interceptors.add(PrettyDioLogger());
  }
  final API _api = API();
  Dio recommendations = Dio();
  Future<Response> createJob(String userId,dynamic data) async {
    try{
      Response response = await _api.sendRequests.post("/customer/$userId/create-job",data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getRecomms(String jobId) async {
    try{
      Response response = await recommendations.get("/match_maids/$jobId");
      return response;
    } catch (e){
      rethrow;
    }
  }
}
