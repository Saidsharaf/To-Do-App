import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archive_tasks/archive_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/done_tasks/done_screen.dart';
import '../../modules/new_tasks/new_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  int currentInedx = 0;
  List<Widget> screens = [
    new_screen(),
    done_screen(),
    archive_screen(),
  ];
  List<String> appName = [
    "new Tasks",
    "Done Tasks",
    "archive tasks",
  ];

  void changeNav(int index) {
    currentInedx = index;
    emit(AppChangeNavBarState());
  }

  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        print("db created");
        database
            .execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT, date TEXT,time TEXT, status TEXT)")
            .then((value) {
          print("table created");
        }).catchError((error) {
          print("error ${error.toString()}");
        });
      },
      onOpen: (database) {
        print("db opened");
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    await database?.transaction((txn) {
      txn
          .rawInsert(
        "INSERT INTO tasks(title,date,time,status) VALUES('$title','$date','$time','new')",
      )
          .then((value) {
        print("$value row inserted");
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print("error insert new row ${error.toString()}");
      });
      return Future(() => null);
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    database!.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if (element["status"] == "new")
          newTasks.add(element);
        else if (element["status"] == "done")
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
    ;
  }

  void updateDatabase({
    @required String? status,
    @required int? id,
  }) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [
      '$status',
      id,
    ]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void DeleteDatabase({
    
    @required int? id,
  }) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
    .then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheet({required IconData icon, required bool isShow}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
