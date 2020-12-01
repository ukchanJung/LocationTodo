import 'package:flutter/material.dart';

class Task {
  String name;
  DateTime start;
  DateTime end;
  DateTime writeTime;
  String memo;
  bool ischecked = false;
  bool favorite = false;
  double x;
  double px;
  double y;
  double py;
  Rect boundary;

  Task(this.writeTime,{this.name = '메모', this.start, this.end, this.memo, this.boundary});
}