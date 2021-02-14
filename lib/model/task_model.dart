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
  double floor;
  List<Rect> boundarys = [];


  Task(
    this.writeTime, {
    this.name = '메모',
    this.start,
    this.end,
    this.memo,
    this.boundarys,
    this.z,
    this.floor,
  });
  Task.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    name = json["name"];
    start = json["start"].toDate();
    end = json["end"].toDate();
    writeTime = json["writeTime"].toDate();
    memo = json["memo"];
    ischecked = json["ischecked"];
    favorite = json["favorite"];
    x = json["x"];
    y = json["y"];
    z = json["z"];
    floor = json['floor'].toDouble();
    Iterable jsonBoundarys = json["boundarys"];
    boundarys = jsonBoundarys
        .map((e) => Rect.fromPoints(
            Offset(e["firstX"].toDouble(), e["firstY"].toDouble()), Offset(e["endX"].toDouble(), e["endY"].toDouble())))
        .toList();
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
    map["floor"] = floor;
    // boundarys.map((e){ map["boundarys"] =[e.topLeft.dx, e.topLeft.dy, e.bottomRight.dx, e.bottomRight.dy]; });
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
class Task2 {
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
  double floor;
  List<Offset> boundarys = [];

  Task2(
    this.writeTime, {
    this.name = '메모',
    this.start,
    this.end,
    this.memo,
    this.boundarys,
    this.z,
    this.floor,
  });
  Task2.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    name = json["name"];
    start = json["start"].toDate();
    end = json["end"].toDate();
    writeTime = json["writeTime"].toDate();
    memo = json["memo"];
    ischecked = json["ischecked"];
    favorite = json["favorite"];
    x = json["x"];
    y = json["y"];
    z = json["z"];
    floor = json['floor'].toDouble();
    Iterable jsonBoundarys = json["boundarys"];
    boundarys = jsonBoundarys
        .map((e) => Offset(e['dx'].toDouble(),e['dy'].toDouble()))
        .toList();
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
    map["floor"] = floor;
    // boundarys.map((e){ map["boundarys"] =[e.topLeft.dx, e.topLeft.dy, e.bottomRight.dx, e.bottomRight.dy]; });
    map["boundarys"] = boundarys.map((e) => {
      "dx": e.dx,
      "dy": e.dy,
    }).toList();
    return map;
  }

  Task2.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() {
    return 'Task2{name: $name, writeTime: $writeTime}';
  }
}
