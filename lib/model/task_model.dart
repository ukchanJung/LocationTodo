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
  Rect boundary;
  List<num> sX;
  List<num> sY;
  List<num> eX;
  List<num> eY;


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
    // writeTime = json["writeTime"];
    memo = json["memo"];
    ischecked = json["ischecked"];
    favorite = json["favorite"];
    x = json["x"];
    y = json["y"];
    z = json["z"];
    // boundary = Rect.fromPoints(Offset(), Offset());
    sX = json["topLeftX"].cast<num>();
    sY = json["topLeftY"].cast<num>();
    eX = json["bottomRightX"].cast<num>();
    eY = json["bottomRightY"].cast<num>();
    for (int i = 0; i < sX.length; i++) {
      boundarys.add(Rect.fromPoints(Offset(sX[i],sY[i]), Offset(eX[i],eY[i])));
    }

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
    // boundarys.map((e){ map["boundarys"] =[e.topLeft.dx, e.topLeft.dy, e.bottomRight.dx, e.bottomRight.dy]; });
    map["topLeftX"] = boundarys.map((e)=>e.topLeft.dx).toList();
    map["topLeftY"] = boundarys.map((e)=>e.topLeft.dy).toList();
    map["bottomRightX"] = boundarys.map((e)=>e.bottomRight.dx).toList();
    map["bottomRightY"] = boundarys.map((e)=>e.bottomRight.dy).toList();
    return map;
  }

  Task.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);
}
