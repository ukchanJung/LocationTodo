import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';

class Planner extends StatefulWidget {
  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  TextEditingController addContrl = TextEditingController();
  List<Offset> boundary =[
    Offset(100, 100),
    Offset(500, 100),
    Offset(500, 400),
    Offset(200, 400),
    Offset(200, 200),
    Offset(100, 200),
    Offset(100, 100),

  ];
  List<Line> bLine;
  List<Line> cLine;

  // Line split = Line(Offset(50,300),Offset(600,200));
  Line split = Line(Offset(300,80),Offset(250,430));
  Line intersectLine;

  @override
  void initState() {
    super.initState();
    // boundary.sub
    bLine = boundary.map((e) {
      return Line(boundary[boundary.indexOf(e,1)-1], boundary[boundary.indexOf(e)]);
    }).toList();
    List<dynamic> i=bLine.sublist(1).map((b) {
      if(Intersection().checkCollision(b, split)){
      return Intersection().compute(b, split);
      }
    }).toList();
    i.add(null);
    List<Offset> t=bLine.sublist(1).map((b) {
      if(Intersection().checkCollision(b, split)){
      return Intersection().compute(b, split);
      }
    }).toList();
    print(i);
    t.removeWhere((element) => element == null);
    intersectLine =Line(t.first,t.last);

    // print(t.indexOf(null));
    List<Offset> setB =[];
    boundary.forEach((e) {
      setB.add(e);
      if(i[boundary.indexOf(e)] != null){
        setB.add(i[boundary.indexOf(e)]);
      }
    });
    print(setB);
    int start = setB.indexOf(t.first);
    int end = setB.indexOf(t.last);
    print('$start - $end');
    List temp =setB.sublist(start,end+1);
    print(temp);
    print(setB.sublist(0,setB.length-1).reversed);
    t.forEach((element) {
      temp.remove(element);
    });
    temp.forEach((element) {
      setB.remove(element);
    });
    print(setB.sublist(0,setB.length));

    // cLine = setB.map((e) {
    //   return Line(setB[setB.indexOf(e,1)-1], setB[setB.indexOf(e)]);
    // }).toList();
    // print(cLine);


    // for(int i; i<boundary.length; i++){
    //   setB.insert(i, t[i]);
    // }
    // print(setB);


    // boundary.sublist(start)
    // bLine.forEach((print));
    // print(t);
    // print(bLine.length);
  }

  @override
  void dispose() {
    super.dispose();
    addContrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('플래너'),
      ),
      body: CustomPaint(
        painter: SplitTest(tP:boundary ,lines: bLine, splitLine :split,interSectLine: intersectLine),
      ),
    );
  }

  Row buildplaner() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(border: Border(right: BorderSide())),
            child: ListView(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: addContrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '작업을 입력해주세요',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('등록'),
                        ),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  children: [
                    ExpansionTile(
                      title: Text('d2'),
                      children: [
                        Container(height: 50,color: Colors.red,)
                      ],
                    )
                  ],
                  title: Text('D1'),
                  onExpansionChanged: (v){
                    print(v);
                  },
                  trailing: ElevatedButton(onPressed: () {  }, child: Text('추가'),),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                12,
                (i) => Container(
                  width: 100,
                  decoration: BoxDecoration(border: Border(right: BorderSide())),
                  child: Center(child: Text('${i + 1}')),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Plan {
  List<Plan> lowPlan;
  DateTime start;
  DateTime end;
  bool isCheck = false;
  int id;
  String name;

  Plan({this.lowPlan, this.start, this.end});

}
class SplitTest extends CustomPainter {
  List<Offset> tP ;
  double s = 1;
  List<Line> lines;
  Line splitLine;
  Line interSectLine;

  SplitTest({this.tP, this.s, this.lines, this.splitLine, this.interSectLine});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint4 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15.0
      ..color = Color.fromRGBO(255, 0, 0, 0.5);
    Paint paint5 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..color = Color.fromRGBO(255, 0, 0, 0.5);
    Paint paint7 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..color = Color.fromRGBO(0, 0, 255, 0.5);
    Paint paint8 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..color = Color.fromRGBO(0, 255, 0, 0.5);
    Paint paint9 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill
      ..color = Color.fromRGBO(0, 255, 0, 0.5);
    Paint paint6 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..color = Color.fromRGBO(255, 0, 0, 0.3);

    Path p = Path();
    p.moveTo(tP[0].dx, tP[0].dy);
    tP.forEach((e) {
      p.lineTo(e.dx, e.dy);
    });
    // p.close();
    Path t =Path();
    for(final PathMetric metric in p.computeMetrics()){
      t.addPath(metric.extractPath(0,metric.length*0.7 ), Offset.zero);
    }
    // print(t);
    // p.addPolygon([interSectLine.p1,interSectLine.p2], true);
    Path i =Path();
    i.moveTo(interSectLine.p1.dx,interSectLine.p1.dy );
    i.lineTo(interSectLine.p2.dx, interSectLine.p2.dy);
    p.addPath(i, Offset.zero);
     canvas.drawPath(p, paint6);
     canvas.drawPath(p, paint8);
     p.close();
    // print(p);
     // canvas.drawPath(t, paint9);
     // canvas.drawPath(p, paint5);

    // canvas.drawLine(splitLine.p1, splitLine.p2, paint8);


    canvas.drawPoints(PointMode.points, tP, paint4);
    // canvas.drawPoints(PointMode.polygon, tP, paint5);
    lines.forEach((e) {
      canvas.drawLine(e.p1, e.p2, paint7);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
