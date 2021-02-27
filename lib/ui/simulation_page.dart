import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/data_read.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';

class SimulationPage extends StatefulWidget {
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  double a3Ratio = 420 / 297;
  double setRatio = 1 / (1.5 / (420 / 297));
  Offset _offset = Offset.zero;
  List<Map> schedule = [
    {'name': '토목공사', 'start': 0, 'end': 4},
    {'name': '가설공사', 'start': 1, 'end': 3},
    {'name': '구조공사', 'start': 3, 'end': 20},
    {'name': '마감공사', 'start': 22, 'end': 28},
    {'name': '설비전기', 'start': 10, 'end': 26},
    {'name': '조경공사', 'start': 24, 'end': 29},
  ];
  List<SimulationTask> simulList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공정관리'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              AspectRatio(
                aspectRatio: setRatio,
                child: Container(
                  color: Colors.redAccent,
                  child: LayoutBuilder(builder: (context, a1) {
                    return Column(
                      children: [
                        Container(
                          width: a1.maxWidth,
                          height: a1.maxWidth / a3Ratio,
                          child: Stack(
                            children: [
                              DView(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text('작업추가'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: a1.maxWidth / 2,
                                height: a1.maxWidth / a3Ratio / 2,
                                child: DView(),
                              ),
                              Container(
                                width: a1.maxWidth / 2,
                                height: a1.maxWidth / a3Ratio / 2,
                                child: DView(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, b1) {
                  return Container(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: List.generate(
                                30,
                                (index) => Expanded(
                                  child: Container(
                                    height: 20,
                                    child: Center(
                                      child: AutoSizeText(
                                        'M+$index',
                                        maxLines: 1,
                                        minFontSize: 3,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: schedule
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.only(bottom: 2.0),
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: List.generate(
                                                30,
                                                (index) => Expanded(
                                                  child: Tooltip(
                                                    message: e['name'],
                                                    child: Container(
                                                      height: 15,
                                                      child: Center(),
                                                      decoration: BoxDecoration(
                                                        color: index >= e['start'] && index < e['end']
                                                            ? Colors.red
                                                            : Colors.transparent,
                                                        border: Border.all(color: Colors.white54),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                left:
                                                    (b1.maxWidth / 30) * ((e['end'] - e['start']) / 2 + e['start'] - 1),
                                                child: Text(e['name']))
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            )
                          ],
                        ),
                        Divider(),
                        Expanded(
                          child: Container(
                            child: Card(
                              child: WeekCalendar(),
                            ),
                            width: b1.maxWidth,
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WeekCalendar extends StatefulWidget {
  @override
  _WeekCalendarState createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  List<DateTime> calendars = List.generate(365, (index) => DateTime.now().add(Duration(days: -20 + index)));
  ScrollController _gantContrl = ScrollController(initialScrollOffset: 400, keepScrollOffset: true);
  ScrollController gantControl = ScrollController();
  DateFormat weekfomat = DateFormat.E();
  List<TaskData> tasks;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gantContrl.addListener(() {
      gantControl.jumpTo(_gantContrl.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          controller: _gantContrl,
          scrollDirection: Axis.horizontal,
          //달력간트차트
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: calendars
                .map(
                  (e) => Container(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          e.weekday == 7 ? Text(weekfomat.format(e), style: TextStyle(color: Colors.red)) : Container(),
                          e.weekday == 6
                              ? Text(weekfomat.format(e), style: TextStyle(color: Colors.blue))
                              : Container(),
                          e.weekday != 7 && e.weekday != 6 ? Text(weekfomat.format(e)) : Container(),
                          Text('${e.month}.${e.day}'),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        FutureBuilder(
            future: ReadTasks(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return Center(child: CircularProgressIndicator());
              } else {
                tasks = snapshot.data;
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: tasks.map((e) {
                        return Container(
                          // decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(e.name),
                                trailing: e.start == null
                                    ? Text('일정을 선택해주세요')
                                    : Text('${e.start.month}-${e.start.day} ~ ${e.end.month}-${e.end.day}'),
                                // leading: Text(e.boundarys.length.toString()),
                                selected: e.favorite,
                                onTap: () {
                                  setState(() {
                                    // tasks.singleWhere((element) => element.favorite == true).favorite = false;
                                    e.favorite = !e.favorite;
                                    print(e.favorite);
                                  });
                                },
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                controller: gantControl,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: calendars
                                      .map((d) => Container(
                                            width: 50,
                                            height: 5,
                                            color: e.start.isAfter(d.add(Duration(days: 1))) || e.end.isBefore(d)
                                                ? Colors.transparent
                                                : Colors.red,
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            })
      ],
    );
  }
}

class DView extends StatefulWidget {
  @override
  _DViewState createState() => _DViewState();
}

class _DViewState extends State<DView> {
  PhotoViewController _pContrl = PhotoViewController();
  List<Offset> temp =[];
  Offset hover=Offset(0,0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pContrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRect(
        child: PhotoView.customChild(
            minScale: 1.0,
            maxScale: 20.0,
            initialScale: 1.0,
            controller: _pContrl,
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
            child: Stack(
              children: [
                Listener(
                  onPointerHover: (h){
                    setState(() {
                      hover =h.localPosition;
                    });
                  },
                  child: PositionedTapDetector(
                    onTap: (m){
                      temp.add(Offset(m.relative.dx,m.relative.dy));
                    },
                    child: Stack(
                      children: [
                        Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                        CustomPaint(
                          painter: TaskBoundary(tP: [
                            ...temp,
                            hover
                          ],s: 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class SimulationTask{
  String name;
  List<Offset> boundary;
  DateTime start;
  DateTime end;
  bool select;
  bool cp;
}
class TaskBoundary extends CustomPainter {
  List<Offset> tP;
  double s = 1;

  TaskBoundary({this.tP, this.s});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint4 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0 / s
      ..color = Color.fromRGBO(255, 0, 0, 1);
    Paint paint5 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0 / s
      ..style = PaintingStyle.fill
      ..color = Color.fromRGBO(255, 0, 0, 1);
    Paint paint6 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0 / s
      ..style = PaintingStyle.fill
      ..color = Color.fromRGBO(255, 0, 0, 0.3);

    Path p = Path();
    p.moveTo(tP[0].dx, tP[0].dy);
    tP.forEach((e) {
      p.lineTo(e.dx, e.dy);
    });
    p.close();
    tP == [] ? null : canvas.drawPath(p, paint6);

    tP == [] ? null : canvas.drawPoints(PointMode.points, tP, paint4);
    tP == [] ? null : canvas.drawPoints(PointMode.polygon, tP, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
