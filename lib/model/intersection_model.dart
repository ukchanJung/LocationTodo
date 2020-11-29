import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class IntersectPoint{
  List<Line> lines;

  Offset IntersectTwoLine(Line line1, Line line2) {
    Offset p1 = line1.p1;
    Offset p2 = line1.p2;
    Offset p3 = line2.p1;
    Offset p4 = line2.p2;
    double x1,x2,y1,y2,x3,x4,y3,y4;
    double m1,m2;

    // let sign1 = (p2.x-p1.x)*(p3.y-p1.y) - (p3.x-p1.x)*(p2.y-p1.y);
    //
    // let sign2 = (p2.x-p1.x)*(p4.y-p1.y) - (p4.x-p1.x)*(p2.y-p1.y);
    //
    //
    //
    // let sign3 = (p4.x-p3.x)*(p1.y-p3.y) - (p1.x-p3.x)*(p4.y-p3.y);
    //
    // let sign4 = (p4.x-p3.x)*(p2.y-p3.y) - (p2.x-p3.x)*(p4.y-p3.y);
    //


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
  List<Offset> Intersections(List<Line> lines) {
    List<Offset> resultSet = [];
    for(var i = 0; i < lines.length; i++) {
      for(var j = 0; j < lines.length; j++) {
        if (lines[i] == lines[j]) {
          continue;
        } else if (IntersectTwoLine(lines[i], lines[j])==null){
          continue;
        }
        Offset point = IntersectTwoLine(lines[i], lines[j]);
        resultSet.add(point);
      }
    }
    return resultSet;
  }
}