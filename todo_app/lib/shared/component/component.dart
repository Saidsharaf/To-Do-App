import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'package:todo_app/shared/cubit/cubit.dart';




Widget defultFormField({
  @required TextEditingController? controller,
  @required TextInputType? type,
  @required String? lable,
  String? msg,
  @required IconData? prefix,
  IconData? suffix,
  bool isScure = false,
  VoidCallback? iconPress,
  VoidCallback? onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isScure,
      onTap: onTap,
      validator: (value) {
        if (value!.isEmpty) {
          return msg;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: lable,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: iconPress,
                icon: Icon(
                  suffix,
                ))
            : null,
      ),
    );

Widget buildTask(Map model, context) => Dismissible(
      key: Key(model["id"].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                "${model['time']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDatabase(
                  status: "done",
                  id: model["id"],
                );
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDatabase(
                  status: "archive",
                  id: model["id"],
                );
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).DeleteDatabase(id: model["id"]);
      },
    );

Widget Notasks({
  @required List<Map>? tasks,
}) {
  return ConditionalBuilder(
    condition: tasks!.length > 0,
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildTask(tasks[index], context),
      separatorBuilder: (context, index) => Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey[300],
      ),
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            "No tasks yet ,please enter new tasks.",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}
