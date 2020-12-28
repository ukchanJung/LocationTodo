import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Line {
  Offset p1;
  Offset p2;

  Line(this.p1, this.p2);

  double length() {
    double _length;
    double x = p2.dx - p1.dx;
    double y = p2.dy - p1.dy;
    _length = sqrt(pow(x, 2) + pow(y, 2));
    return _length;
  }

  double degree() {
    double _degree;
    double x = p2.dx - p1.dx;
    double y = p2.dy - p1.dy;
    _degree = atan2(y, x) * (180 / pi);
    return _degree;
  }

  Line.fromJson(Map<String, dynamic> json, {DocumentReference reference}) {
    p1 = Offset(json["startX"], json["startY"]);
    p2 = Offset(json["endX"], json["endY"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["startX"] = p1.dx;
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
