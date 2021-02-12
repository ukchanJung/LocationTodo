import 'dart:ui';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
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
  double sS = 1;
  double x;
  double y;
  List<Offset>bb=[];


  GridMaker(this.grids, this.gScale, this._inputP, {this.pointList, this.deviceWidth, this.cordinate, this.sS, this.x, this.y});

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
      ..strokeWidth = 500.0 / sS;
    Paint paint3 = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50.0 / sS;
    Paint paint4 = Paint()
      ..color = Colors.purpleAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0 /sS;

    grids.forEach((e) {
      canvas.drawLine(Offset(e.startX.toDouble(), -e.startY.toDouble()) / scale + cordinate,
          Offset(e.endX.toDouble(), -e.endY.toDouble()) / scale + cordinate, paint);
    });

    // List<Point<double>> parseList =
    //     pointList.map((e) => Point(e.dx * deviceWidth + cordinate.dx, e.dy * deviceWidth + cordinate.dy)).toList();
    // Point<double> parsePoint = Point(_inputP.dx, _inputP.dy);
    // List<Point> cpl = Closet(selectPoint: parsePoint, pointList: parseList).minRect(parsePoint);
    // canvas.drawPoints(PointMode.points, [_inputP], paint4);
    // canvas.drawRect(Rect.fromPoints(Offset(cpl.first.x, cpl.first.y), Offset(cpl.last.x, cpl.last.y)), stroke);
    // canvas.drawPoints(PointMode.points, pointList.map((e) => e * deviceWidth + cordinate).toList(), paint2);

    Rect b =Rect.fromCenter(center: Offset(deviceWidth/2-x,(deviceWidth/(420/297))/2-y), width: deviceWidth*0.9/sS, height: (deviceWidth/(420/297))*0.9/sS);
    Line aa = Line(b.topLeft,b.topRight);
    List<Line> temp=[];
    grids.forEach((e) {
      temp.add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble()) / scale + cordinate,
          Offset(e.endX.toDouble(), -e.endY.toDouble()) / scale + cordinate));
    });
    //
    temp.forEach((e){
      if(Intersection().checkCollision(e, aa)==false){
      } else{
        bb.add(Intersection().compute(e, aa));
      }
    });
    canvas.drawRect(b, paint4);
    canvas.drawPoints(PointMode.points, bb == [] ? [Offset(400,400)] : bb, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
