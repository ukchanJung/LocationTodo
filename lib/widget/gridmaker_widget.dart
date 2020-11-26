import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class GridMaker extends CustomPainter {
  List<Grid> grids = [];

  List<Line> lines = [];

  GridMaker(this.grids);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..color = Colors.red;



    // canvas.drawLine(Offset(grids[2].x.toDouble(), 0), Offset(grids[2].x.toDouble(),double.infinity), paint);
    // canvas.drawLine(Offset(100, 0), Offset(100,100), paint);
    // canvas.drawRect(Rect.fromPoints(Offset(0, 0), Offset(100,200)), paint);
    grids.forEach((e) {
         if (e.name.contains('X')) {
           canvas.drawLine(Offset(e.x.toDouble(), 0), Offset(e.x.toDouble(),size.height), paint);
         } else {
           canvas.drawLine(Offset(0, e.y.toDouble()), Offset(size.width,e.y.toDouble()), paint);
         }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
