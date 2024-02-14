import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/component/component.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class archive_screen extends StatelessWidget {
  const archive_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archiveTasks;
        return Notasks(tasks: tasks);
      },
    );
  }
}
