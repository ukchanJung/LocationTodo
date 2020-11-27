import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class GridMaker extends CustomPainter {
  double gScale ;
  List<Grid> grids = [];

  GridMaker(this.grids, this.gScale);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2.0
      ..color = Colors.red;

    grids.forEach((e) {
         if (e.name.contains('X')) {
           canvas.drawLine(Offset(e.x.toDouble()/gScale, 0), Offset(e.x.toDouble()/gScale,size.height), paint);
         } else if(e.name.contains('Y')){
           canvas.drawLine(Offset(0, e.y.toDouble()/gScale), Offset(size.width,e.y.toDouble()/gScale), paint);
         }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
