import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/ui/location_image_page.dart';

class LocationTodo extends StatefulWidget {

  @override
  _LocationTodoState createState() => _LocationTodoState();
}



class Task {
  String name;
  DateTime start;
  DateTime end;
  String memo;

  Task({this.name = '메모', this.start, this.end, this.memo});
}

