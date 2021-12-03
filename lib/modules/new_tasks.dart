import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/component/build_task_item.dart';
import 'package:to_do_app/shared/cubit.dart';
import 'package:to_do_app/shared/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).tasks;
          return taskBuilder(tasks: tasks);
        },
        listener: (context, state) {});
  }
}
