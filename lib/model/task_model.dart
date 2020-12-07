import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  double z;
  double py;
  List<Rect> boundarys = [];


  Task(
    this.writeTime, {
    this.name = '메모',
    this.start,
    this.end,
    this.memo,
    this.boundarys,
    this.z,
  });
  Task.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    name = json["name"];
    start = json["start"];
    end = json["end"];
    writeTime = json["writeTime"].toDate();
    memo = json["memo"];
    ischecked = json["ischecked"];
    favorite = json["favorite"];
    x = json["x"];
    y = json["y"];
    z = json["z"];
    Iterable jsonBoundarys = json["boundarys"];
    print(jsonBoundarys);
    boundarys = jsonBoundarys.map((e) => Rect.fromPoints(Offset(e["firstX"],e["firstY"]), Offset(e["endX"],e["endY"]))).toList();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["start"] = start;
    map["end"] = end;
    map["writeTime"] = writeTime;
    map["memo"] = memo;
    map["ischecked"] = ischecked;
    map["favorite"] = favorite;
    map["x"] = x;
    map["y"] = y;
    map["z"] = z;
    boundarys.map((e){ map["boundarys"] =[e.topLeft.dx, e.topLeft.dy, e.bottomRight.dx, e.bottomRight.dy]; });
    map["boundarys"] = boundarys.map((e) => {
      "firstX": e.topLeft.dx,
      "firstY": e.topLeft.dy,
      "endX": e.bottomRight.dx,
      "endY": e.bottomRight.dy,
    }).toList();
    return map;
  }

  Task.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);
}
