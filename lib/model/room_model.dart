import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';

class Room{
  String name;
  String id;
  Rect rect;
  num FL;
  num SL;
  num sealL;
  num x;
  num y;
  num z;
  double left;
  double top;
  double right;
  double bottom;

  Room({this.name, this.id, this.rect, this.x, this.y, this.z,this.sealL, this.left, this.top, this.right, this.bottom});
}

class CallOut{
  String name;
  Drawing parent;
  num readCount;
  Rect rect;
  num x;
  num y;
  num z;
}

class DetailInfo{
  String name;
  String category;
  Rect rect;
  num x;
  num y;
  num z;
}
enum OcrCategory { Room, CallOut, DetailInfo }