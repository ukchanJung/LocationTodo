import 'dart:ui';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/intersection_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class GridMaker extends CustomPainter {
  double gScale ;
  List<Grid> grids = [];
  List<Line> lines = [];
  Offset _inputP;

  GridMaker(this.grids, this.gScale, this._inputP);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 1.0
      ..color = Colors.red;
    Paint paint2 = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    Paint paint3 = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;



    grids.forEach((e) {
      if (e.name.contains('X')){
        lines.add(Line(Offset(e.x.toDouble()/gScale, 0), Offset(e.x.toDouble()/gScale,size.height)));
      } else if(e.name.contains('Y')) {
        lines.add(Line(Offset(0, e.y.toDouble()/gScale), Offset(size.width,e.y.toDouble()/gScale)));
      }
    });




    grids.forEach((e) {
         if (e.name.contains('X')) {
           canvas.drawLine(Offset(e.x.toDouble()/gScale, 0), Offset(e.x.toDouble()/gScale,size.height), paint);
         } else if(e.name.contains('Y')){
           canvas.drawLine(Offset(0, e.y.toDouble()/gScale), Offset(size.width,e.y.toDouble()/gScale), paint);
         }
    });
    canvas.drawPoints(PointMode.points, IntersectPoint().Intersections(lines), paint2);

    List<Offset> _iPs = IntersectPoint().Intersections(lines);


    Offset pp =_iPs.reduce((a, b) => max(Point(a.dx, a.dy).distanceTo(Point(_inputP.dx,_inputP.dx)), Point(b.dx, b.dy).distanceTo(Point(_inputP.dx,_inputP.dx))));

    canvas.drawPoints(PointMode.points, [_inputP], paint3);
    // canvas.drawCircle(pp, 10, paint3);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
