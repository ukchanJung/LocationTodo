import 'dart:developer';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/counter_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class Planner extends StatefulWidget {
  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  TextEditingController addContrl = TextEditingController();
  List<Offset> boundary = [
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
  Line split = Line(Offset(300, 80), Offset(250, 430));
  Line intersectLine;
  Plan plan = Plan()..lowPlan = [Plan(), Plan()];
  List<int> testDay = List.generate(10, (index) => index).toList();
  ScrollController _scrollController = ScrollController();
  List<DateTime> calendars = List.generate(21, (index) => DateTime.now().add(Duration(days: -10 + index)));

  @override
  void initState() {
    super.initState();
    // boundary.sub
    bLine = boundary.map((e) {
      return Line(boundary[boundary.indexOf(e, 1) - 1], boundary[boundary.indexOf(e)]);
    }).toList();
    List<dynamic> i = bLine.sublist(1).map((b) {
      if (Intersection().checkCollision(b, split)) {
        return Intersection().compute(b, split);
      }
    }).toList();
    i.add(null);
    List<Offset> t = bLine.sublist(1).map((b) {
      if (Intersection().checkCollision(b, split)) {
        return Intersection().compute(b, split);
      }
    }).toList();
    print(i);
    t.removeWhere((element) => element == null);
    intersectLine = Line(t.first, t.last);

    // print(t.indexOf(null));
    List<Offset> setB = [];
    boundary.forEach((e) {
      setB.add(e);
      if (i[boundary.indexOf(e)] != null) {
        setB.add(i[boundary.indexOf(e)]);
      }
    });
    print(setB);
    int start = setB.indexOf(t.first);
    int end = setB.indexOf(t.last);
    print('$start - $end');
    List temp = setB.sublist(start, end + 1);
    print(temp);
    print(setB.sublist(0, setB.length - 1).reversed);
    t.forEach((element) {
      temp.remove(element);
    });
    temp.forEach((element) {
      setB.remove(element);
    });
    print(setB.sublist(0, setB.length));

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
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('플래너'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(context.read<DivideCounter>().value);
        },
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 600, height: 800, child: DividePlaner(plan: plan)),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          children: calendars
                              .map(
                                (e) => Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  child: Center(child: Text('${e.month}.${e.day}')),
                                )
                              )
                              .toList()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            context.watch<DivideCounter>().value,
                            (index) => Row(
                                  children: calendars
                                      .map(
                                        (e) => Container(
                                          child: DragTarget(
                                            onAccept: (List k) {
                                              setState(() {
                                                context.read<DivideCounter>().gants[index].plan = k[0];
                                                k[0].start = e;
                                                k[0].end = k[0].start.add(Duration(days: k[1]));
                                                print(k[0].start);
                                                print(k[0].end);
                                                print(k[1]);
                                              });
                                            },
                                            builder: (context, candidateData, rejectedData) {
                                              return Container(
                                                width: 50,
                                                height: 50,
                                                decoration: context.watch<DivideCounter>().gants[index].plan != null
                                                    ? BoxDecoration(
                                                        border: Border.all(),
                                                        color: context
                                                                    .watch<DivideCounter>()
                                                                    .gants[index]
                                                                    .plan
                                                                    .start
                                                                    .isAfter(e) ||
                                                                context
                                                                    .watch<DivideCounter>()
                                                                    .gants[index]
                                                                    .plan
                                                                    .end
                                                                    .isBefore(e)
                                                            ? Colors.transparent
                                                            : Colors.red,
                                                      )
                                                    : BoxDecoration(
                                                        border: Border.all(),
                                                      ),
                                                child: Center(child: Text('-')),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  CustomPaint buildCustomPaint() {
    return CustomPaint(
      painter: SplitTest(tP: boundary, lines: bLine, splitLine: split, interSectLine: intersectLine),
    );
  }
}

class DividePlaner extends StatefulWidget {
  Plan plan;

  DividePlaner({this.plan});

  @override
  _DividePlanerState createState() => _DividePlanerState();
}

class _DividePlanerState extends State<DividePlaner> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < c.maxHeight) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.art_track),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.plan.lowPlan.add(Plan());
                        context.read<DivideCounter>().up();
                      });
                    },
                    child: Text('+'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('-'),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.plan.lowPlan
                      .map((e) => Expanded(
                            child: LayoutBuilder(builder: (context, s) {
                              return Draggable(
                                data: [e, (s.maxWidth).toStringAsFixed(0).length],
                                childWhenDragging: Container(),
                                feedback: Center(
                                    child: Container(
                                  width: s.maxWidth,
                                  height: s.maxHeight,
                                  color: Colors.deepOrange,
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Material(
                                      elevation: 10,
                                      color: Color.fromRGBO(
                                          Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            e.lowPlan == null ? e.lowPlan = [Plan(), Plan()] : e.lowPlan.add(Plan());
                                            print(widget.plan.lowPlan);
                                            context.read<DivideCounter>().up();
                                            print(context.read<DivideCounter>().value);
                                          });
                                        },
                                        onLongPress: () {
                                          print(e.start);
                                        },
                                        child: e.lowPlan != null
                                            ? DividePlaner(plan: e)
                                            : Container(child: Center(child: Text('${e.start}'))),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ))
                      .toList()),
            ),
          ],
        );
      }
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.art_track),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.plan.lowPlan.add(Plan());
                      context.read<DivideCounter>().up();
                    });
                  },
                  child: Text('+'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('-'),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.plan.lowPlan
                    .map((e) => Expanded(
                          child: LayoutBuilder(builder: (context, s) {
                            return Draggable(
                              data: [e, (s.maxWidth).toStringAsFixed(0).length],
                              childWhenDragging: Container(),
                              feedback: Center(
                                  child: Container(
                                width: s.maxWidth,
                                height: s.maxHeight,
                                color: Colors.deepOrange,
                              )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Material(
                                    elevation: 10,
                                    color: Color.fromRGBO(
                                        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          e.lowPlan == null ? e.lowPlan = [Plan(), Plan()] : e.lowPlan.add(Plan());
                                          print(widget.plan.lowPlan);
                                          context.read<DivideCounter>().up();
                                          print(context.read<DivideCounter>().value);
                                        });
                                      },
                                      onLongPress: () {
                                        print(e.start);
                                      },
                                      child: e.lowPlan != null
                                          ? DividePlaner(plan: e)
                                          : Container(child: Center(child: Text('${e.start}'))),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ))
                    .toList()),
          )
        ],
      );
    });
  }
}

class PlanGant {
  Plan plan;
  DateTime start;
  DateTime end;
}

class Plan with ChangeNotifier {
  List<Plan> lowPlan;

  DateTime start;
  DateTime end;
  bool isCheck = false;
  int id;
  String name;
  int count = 2;

  Plan({this.lowPlan, this.start, this.end});
}

class SplitTest extends CustomPainter {
  List<Offset> tP;

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
    Path t = Path();
    for (final PathMetric metric in p.computeMetrics()) {
      t.addPath(metric.extractPath(0, metric.length * 0.7), Offset.zero);
    }
    // print(t);
    // p.addPolygon([interSectLine.p1,interSectLine.p2], true);
    Path i = Path();
    i.moveTo(interSectLine.p1.dx, interSectLine.p1.dy);
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
