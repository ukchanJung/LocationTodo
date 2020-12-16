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
  String id;
  String category;
  Drawing parent;
  num readCount;
  Rect rect;
  Rect viewBoundary;
  double left;
  double top;
  double right;
  double bottom;
  double bLeft;
  double bTop;
  double bRight;
  double bBottom;
  num x;
  num y;
  num z;

  CallOut({
    this.name,
    this.id,
    this.category,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.x,
    this.y,
    this.z,
    this.bLeft,
    this.bTop,
    this.bRight,
    this.bBottom,
  });
}

class DetailInfo{
  String name;
  String category;
  Rect rect;
  double left;
  double top;
  double right;
  double bottom;
  num x;
  num y;
  num z;

  DetailInfo({this.name, this.category, this.left, this.top, this.right, this.bottom, this.x, this.y, this.z});
}
enum OcrCategory { Room, CallOut, DetailInfo }