import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class Intesection {
  Point point;
  List<Gridtestmodel> gridList;
  num A, B, E;
  num C, D, F;

  Offset compute(Line i, Line j) {
    num x1 = i.p1.dx;
    num y1 = i.p1.dy;
    num x2 = i.p2.dx;
    num y2 = i.p2.dy;
    num x3 = j.p1.dx;
    num y3 = j.p1.dy;
    num x4 = j.p2.dx;
    num y4 = j.p2.dy;

    A = y2 - y1;
    B = x1 - x2;
    E = (y2 - y1) * x1 + (x1 - x2) * y1;

    C = y4 - y3;
    D = x3 - x4;
    F = (y4 - y3) * x3 + (x3 - x4) * y3;

    double DE = (A * D) - (B * C);

    if (DE == 0) {
      return null;
    } else {
      num X = ((E * D) - (B * F)) / DE;
      num Y = ((A * F) - (E * C)) / DE;
      return Offset(X, Y);
    }
  }

  checkCollision(Line i, Line j) {
    Offset p1 = i.p1;
    Offset p2 = i.p2;
    Offset p3 = j.p1;
    Offset p4 = j.p2;

    var sign1 = (p2.dx - p1.dx) * (p3.dy - p1.dy) - (p3.dx - p1.dx) * (p2.dy - p1.dy);
    var sign2 = (p2.dx - p1.dx) * (p4.dy - p1.dy) - (p4.dx - p1.dx) * (p2.dy - p1.dy);

    var sign3 = (p4.dx - p3.dx) * (p1.dy - p3.dy) - (p1.dx - p3.dx) * (p4.dy - p3.dy);
    var sign4 = (p4.dx - p3.dx) * (p2.dy - p3.dy) - (p2.dx - p3.dx) * (p4.dy - p3.dy);

    return sign1 * sign2 < 0 && sign3 * sign4 < 0;
  }

  List<Offset> computeLines(List<Line> lines) {
    List<Offset> resultSet = [];
    for (var i = 0; i < lines.length; i++) {
      for (var j = 0; j < lines.length; j++) {
        if (lines[i] == lines[j]) {
          continue;
        } else if (checkCollision(lines[i], lines[j]) == false) {
          continue;
        } else if (compute(lines[i], lines[j]) == null) {
          continue;
        }
        Offset point = compute(lines[i], lines[j]);
        resultSet.add(point);
      }
    }
    return resultSet;
  }
}
