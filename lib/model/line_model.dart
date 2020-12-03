import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Line {
  Offset p1;
  Offset p2;

  Line(this.p1, this.p2);

  Line.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    p1 = Offset(json["startX"], json["startY"]);
    p2 = Offset(json["endX"], json["endY"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["startX"] = p1.dx;
    map["startY"] = p1.dy;
    map["endX"] = p2.dx;
    map["endY"] = p2.dy;
    return map;
  }

  Line.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data(), reference: snapshot.reference);

  @override
  bool operator ==(Object other) {
    if (other is Line) {
      Line otherLine = other;
      return this.p1 == otherLine.p1 && this.p2 == otherLine.p2;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}
