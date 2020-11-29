import 'package:flutter/material.dart';

class Line {
  Offset p1;
  Offset p2;

  Line(this.p1, this.p2);
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
