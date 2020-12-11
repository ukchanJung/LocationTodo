import 'package:flutter/cupertino.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';

class Room{
  String name;
  String id;
  Rect rect;
  int FL;
  int SL;
  int SealL;
  num x;
  num y;
  num z;

  Room({this.name, this.id, this.rect, this.x, this.y, this.z});
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