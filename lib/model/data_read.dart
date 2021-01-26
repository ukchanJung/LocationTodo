import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';

Future<List> ReadTasks() async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  QuerySnapshot read = await _db.collection('tasks').get();
   List<Task> tasks = read.docs.map((e) => Task.fromSnapshot(e)).toList();
   return tasks;
}