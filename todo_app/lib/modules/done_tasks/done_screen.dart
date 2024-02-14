import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/component/component.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import '../../shared/cubit/states.dart';

class done_screen extends StatelessWidget {
  const done_screen({super.key});

  @override
  Widget build(BuildContext context) {
      return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return Notasks(tasks: tasks);
        },
    );

  }
}