import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit.dart';

Widget buildTaskItem(Map model, context) => Dismissible(
  child:   Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.teal,
              child: Text(
                '${model['time']}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              color: Colors.grey[200],
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        AppCubit.get(context)
                            .updateData(status: 'done', id: model['id']);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.archive,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        AppCubit.get(context)
                            .updateData(status: 'archive', id: model['id']);
                      })
                ],
              ),
            )
          ],
        ),
      ),
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);
Widget taskBuilder({required List<Map>tasks})=>BuildCondition(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) =>
        buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,
          size: 100.0,
          color: Colors.grey,),
        Text('No Tasks Yet , Please Add New Task',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),)
      ],
    ),
  ),
);