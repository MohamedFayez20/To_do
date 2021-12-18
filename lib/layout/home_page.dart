import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/cubit.dart';
import 'package:to_do_app/shared/states.dart';

class HomePage extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
        if (state is AppInsertToDataBaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppStates state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(AppCubit.get(context)
                .titles[AppCubit.get(context).currentIndex]),
          ),
          body: BuildCondition(
            condition: state is! AppGetDataBaseLoadingState,
            builder: (context) => AppCubit.get(context)
                .screens[AppCubit.get(context).currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(AppCubit.get(context).fabIcon),
              onPressed: () {
                if (AppCubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertToDataBase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Form(
                          key: formKey,
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Task Title',
                                    prefixIcon: Icon(
                                      Icons.title,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) => {
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString()
                                            });
                                  },
                                  controller: timeController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Task Time',
                                    prefixIcon: Icon(
                                      Icons.watch_later_outlined,
                                    ),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2125-12-05'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  controller: dateController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Task Date',
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                    ),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    AppCubit.get(context).changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  AppCubit.get(context)
                      .changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              }),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.teal,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index) {
              AppCubit.get(context).changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_box), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: 'Archive'),
            ],
          ),
        );
      }),
    );
  }
}
