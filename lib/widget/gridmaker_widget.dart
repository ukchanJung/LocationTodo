import 'dart:ui';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/closest_model.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class GridMaker extends CustomPainter {
  double gScale;
  List<Gridtestmodel> grids = [];
  List<Line> lines = [];
  List<Offset> pointList;
  Offset _inputP;
  double deviceWidth;
  Offset cordinate;

  GridMaker(this.grids, this.gScale, this._inputP, {this.pointList, this.deviceWidth, this.cordinate});

  @override
  void paint(Canvas canvas, Size size) {
    double scale = gScale / deviceWidth;
    Paint paint = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 100.0 / scale
      ..color = Colors.red;
    Paint stroke = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1000.0 / scale
      ..style = PaintingStyle.stroke
      ..color = Colors.amber;
    Paint paint2 = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1000.0 / scale;
    Paint paint4 = Paint()
      ..color = Colors.purpleAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1000.0 / scale;

    grids.forEach((e) {
      canvas.drawLine(Offset(e.startX.toDouble(), -e.startY.toDouble()) / scale + cordinate,
          Offset(e.endX.toDouble(), -e.endY.toDouble()) / scale + cordinate, paint);
    });
    // print(pointList.first*deviceWidth);
    // pointList.forEach((element) {print(element*deviceWidth);});

    List<Point<double>> parseList =
        pointList.map((e) => Point(e.dx * deviceWidth + cordinate.dx, e.dy * deviceWidth + cordinate.dy)).toList();
    Point<double> parsePoint = Point(_inputP.dx, _inputP.dy);
    List<Point> cpl = Closet(selectPoint: parsePoint, pointList: parseList).minRect(parsePoint);
    canvas.drawPoints(PointMode.points, [_inputP], paint4);
    canvas.drawRect(Rect.fromPoints(Offset(cpl.first.x, cpl.first.y), Offset(cpl.last.x, cpl.last.y)), stroke);
    canvas.drawPoints(PointMode.points, pointList.map((e) => e * deviceWidth + cordinate).toList(), paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
