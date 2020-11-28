import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/intersection_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class GridMaker extends CustomPainter {
  double gScale ;
  List<Grid> grids = [];
  List<Line> lines = [];

  GridMaker(this.grids, this.gScale);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 1.0
      ..color = Colors.red;
    Paint paint2 = Paint()
      ..color = Colors.redAccent
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

    List<Offset> _points = IntersectPoint().Intersections(lines);

    canvas.drawPoints(PointMode.points, IntersectPoint().Intersections(lines), paint2);


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
List<Offset> gyojeoms2(List<Line> lines) {
  List<Offset> resultSet = [];
  for(var i = 0; i < lines.length; i++) {
    for(var j = 0; j < lines.length; j++) {
      if (lines[i] == lines[j]) {
        continue;
      } else if (gyojeom(lines[i], lines[j])==null){
        continue;
      }
      Offset point = gyojeom(lines[i], lines[j]);
      resultSet.add(point);
    }
  }
  return resultSet;
}
Offset gyojeom(Line line1, Line line2) {
  Offset p1 = line1.p1;
  Offset p2 = line1.p2;
  Offset p3 = line2.p1;
  Offset p4 = line2.p2;
  double x1,x2,y1,y2,x3,x4,y3,y4;
  double m1,m2;
  x1=p1.dx;
  y1=p1.dy;
  x2=p2.dx;
  y2=p2.dy;
  x3=p3.dx;
  y3=p3.dy;
  x4=p4.dx;
  y4=p4.dy;
  double a,b,c,d,e,f;
  a=y1-y2;
  b=x2-x1;
  c=y3-y4;
  d=x4-x3;
  var den = (y1-y2)*(x4-x3)-(x2-x1)*(y3-y4);
  e=(y1-y2)*x1-(x1-x2)*y1;
  f=(y3-y4)*x3-(x3-x4)*y3;
  var ua = ((x4-x3)*(y1-y3)-(y4-y3)*(x1-x3))/den;
  var ub = ((x2-x1)*(y1-y3)-(y2-y1)*(x1-x3))/den;
  if (den==0)
    return null;
  else if (0>ua&&ua>1&&0>ub&&ub>1)
    return null;
  else  {
    m1=(e*d-b*f)/(a*d-b*c);
    m2=(a*f-e*c)/(a*d-b*c);
    // print("ua$ua");
    // print("ub$ub");
    if (m1<0 && m2>0) {
      m1=(-1)*m1;
    }
    else if (m1>0 && m2<0) {
      m2=(-1)*m2;
    }
    else if (m1<0 && m2<0) {
      m1=(-1)*m1;
      m2=(-1)*m2;
    }}
  return Offset(m1, m2);
}


