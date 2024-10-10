import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maid_easy/api/api.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class DatabaseStates{}

class DataLoadedState extends DatabaseStates{
  final List maids;
  final List services;
  final List contracts;
  DataLoadedState(this.maids, this.services, this.contracts);
}

class DatabaseConnectedState extends DatabaseStates {}

class DataLoadingState extends DatabaseStates{}

class DataInitialState extends DatabaseStates{}

class DatabaseErrorState extends DatabaseStates{
  final String error;
  DatabaseErrorState(this.error);
}

class DatabaseBloc  extends Cubit<DatabaseStates>{
  DatabaseBloc(): super(DataInitialState());

  Db? db;
  APIHandler apiHandler = APIHandler();
  void connectDB() async {
    try{
      db = await Db.create('mongodb+srv://morevansh2003:maideasy@cluster0.da2a1.mongodb.net/test?retryWrites=true&w=majority&appName=Cluster0');
      await db!.open();
    } catch (e) {
      emit(DatabaseErrorState(e.toString()));
    }
  }

  void getMaidCollection(String collName) async {
    // print(db!.state);
    emit(DataLoadingState());
    if(db!.state == State.open){
      try{
        DbCollection maidCollection = db!.collection("maids");
        List maidColl = await maidCollection.find().toList();
        DbCollection servicesCollection = db!.collection("services");
        List servColl = await servicesCollection.find().toList();
        DbCollection contractsCollection = db!.collection("contracts");
        List contColl = await contractsCollection.find().toList();
        emit(DataLoadedState(maidColl,servColl,contColl));
      } catch (e){
        emit(DatabaseErrorState(e.toString()));
      }
    }
  }

  void saveUserOnDatabase(String fullName){
    if(db!.state == State.open && db != null){
      db!.collection("maids");
    }
  }
  
  void writeDataToCollection(String collectionName,dynamic data){
    if(db!.state == State.open && db != null){
      db!.collection(collectionName).insert(data);
    }
  }
}
