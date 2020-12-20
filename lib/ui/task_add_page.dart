import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';

class TaskAddPage extends StatefulWidget {
  @override
  _TaskAddPageState createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        setState(() {
          // tasks.add(Task(DateTime.now(),
          //     name: _task.text, boundarys: boundarys.map((e) => e.boundary).toList()));
          // FirebaseFirestore _db = FirebaseFirestore.instance;
          // CollectionReference dbGrid = _db.collection('tasks');
          // dbGrid.doc(_task.text).set(Task(DateTime.now(),
          //     name: _task.text, boundarys: boundarys.map((e) => e.boundary).toList())
          //     .toJson());
          // _task.text = '';
          // boundarys = [];
        });
      }),
      appBar: AppBar(),
    );
  }
}
