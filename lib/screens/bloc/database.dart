import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class DatabaseStates{}

class DataLoadedState extends DatabaseStates{
  final List maids;
  DataLoadedState(this.maids);
}

class DataInitialState extends DatabaseStates{}

class DatabaseBloc  extends Cubit<DatabaseStates>{
  DatabaseBloc(): super(DataInitialState()){
    connectDB();
  }

  Db? db;
  void connectDB() async {
    db = await Db.create('mongodb+srv://morevansh2003:maideasy@cluster0.da2a1.mongodb.net/test?retryWrites=true&w=majority&appName=Cluster0');
    await db!.open();
  }

  void getAllCollection(String collName) async {
    DbCollection dbCollection = db!.collection("maids");
    List coll = await dbCollection.find().toList();
    emit(DataLoadedState(coll));
  }
}