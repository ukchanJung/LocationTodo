import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';

class Boundary {
  String name;
  DateTime start;
  DateTime end;
  DateTime writeTime;
  String memo;
  bool ischecked = false;
  bool favorite = false;
  List<TaskData> tasksList=[];
  double x;
  double y;
  double z;
  Rect boundary;

  Boundary(
      this.writeTime, {
        this.name = '메모',
        this.start,
        this.end,
        this.memo,
        this.boundary,
        this.z,
      });
  Boundary.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    name = json["name"];
    start = json["start"];
    end = json["end"];
    writeTime = json["writeTime"];
    memo = json["memo"];
    ischecked = json["ischecked"];
    favorite = json["favorite"];
    x = json["x"];
    y = json["y"];
    z = json["z"];
    boundary = json["boundary"];
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
    // map["boundary"] = boundary;
    map["topLeftX"] = boundary.topLeft.dx;
    map["topLeftY"] = boundary.topLeft.dy;
    map["bottomRightX"] = boundary.bottomRight.dx;
    map["bottomRightY"] = boundary.bottomRight.dy;
    return map;
  }

  Boundary.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);
}
