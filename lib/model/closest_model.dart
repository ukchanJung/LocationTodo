import 'dart:math';

import 'package:flutter/gestures.dart';

class Closet {
  Point<double> selectPoint;
  Offset selectOffset;
  List<Point<double>> pointList;
  List<Offset> offsetList;

  Closet({this.selectPoint, this.selectOffset, this.pointList, this.offsetList});

  Point min() {
      return pointList.reduce((v, e) => selectPoint.distanceTo(v) > selectPoint.distanceTo(e) ? e : v);
  }

  Point max() {
    return pointList.reduce((v, e) => selectPoint.distanceTo(v) > selectPoint.distanceTo(e) ? v : e);
  }
}
