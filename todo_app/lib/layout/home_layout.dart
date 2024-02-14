import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/component/component.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class home_layout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
         // backgroundColor: Colors.amber,
          key: scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDatabase(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text,
                  );
                }
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet(
                      elevation: 20,
                      (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsetsDirectional.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                lable: "Task Title",
                                prefix: Icons.title,
                                msg: "can't be empty!",
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              defultFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                lable: "Task Time",
                                prefix: Icons.watch_later_outlined,
                                msg: "time can't be empty!",
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context);
                                  });
                                },
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              defultFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                lable: "Task date",
                                prefix: Icons.calendar_month,
                                msg: " date can't be empty!",
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse("2023-09-01"),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheet(
                    isShow: false,
                    icon: Icons.edit,
                  );
                });
                cubit.changeBottomSheet(
                  isShow: true,
                  icon: Icons.add,
                );
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          appBar: AppBar(
            title: Text(
              cubit.appName[cubit.currentInedx],
            ),
          ),
          body: ConditionalBuilder(
            condition: true,
            builder: (context) => cubit.screens[cubit.currentInedx],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          
          
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentInedx,
            onTap: (value) {
              cubit.changeNav(value);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline,
                ),
                label: "Done",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_outlined,
                ),
                label: "archive",
              ),
            ],
          ),
        );
      }),
    );
  }
}
