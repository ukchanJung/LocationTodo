import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/closest_model.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';

class CordinatePoint {
  String name;
  num x;
  num y;
  String gridX;
  String gridY;

  CordinatePoint({this.name, this.x, this.y, this.gridX, this.gridY});
}

class GridButton extends StatefulWidget {
  @override
  _GridButtonState createState() => _GridButtonState();
}

class _GridButtonState extends State<GridButton> {
  List<Grid> grids = [];
  List<Gridtestmodel> testgrids = [];
  Offset _origin = Offset(0, 0);

  //TODO 도면의 스케일 값을 지정해줘야됨
  double gScale = 421.0 * 500;
  TextEditingController _gridX = TextEditingController();
  TextEditingController _gridY = TextEditingController();
  List<Offset> _iPs;
  List<Offset> _realIPs;
  List<Point> rectPoint = [];
  List<Point> relativeRectPoint = [];
  List<Task> tasks = [];
  PhotoViewController _pContrl = PhotoViewController();
  final GlobalKey _key = GlobalKey();
  final GlobalKey _key2 = GlobalKey();
  double deviceWidth;
  num width;
  num heigh;
  Offset selectIntersect = Offset(0, 0);
  Offset realIntersect = Offset(0, 0);
  List<Drawing> drawings = [];

  @override
  void initState() {
    super.initState();

    void readingGrid() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('origingrid').get();
      testgrids = read.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList();
      //그리드를 통한 교차점 확인
      recaculate();
      //TODO 실시간 연동 바운더리
    }

    readingGrid();
    drawings = [
      Drawing(
        drawingNum: 'A31-003',
        title: '1층 평면도',
        scale: '500',
        localPath: 'asset/photos/A31-003.png',
        originX: 0.7373979439768359,
        originY: 0.23113260932198965,
        witdh: 421,
        height: 297,
      ),
      Drawing(
          drawingNum: 'A31-109',
          title: '1층 확대 평면도',
          scale: '200',
          localPath: 'asset/photos/A31-109.png',
          originX: 1.4458318294031067,
          originY: 0.10323461221782795,
          witdh: 421,
          height: 297),
      Drawing(
          drawingNum: 'A31-110',
          title: '1층 확대 평면도',
          scale: '200',
          localPath: 'asset/photos/A31-110.png',
          originX: 0.8621306563916183,
          originY: 0.103544052143084,
          witdh: 421,
          height: 297),
      Drawing(
        drawingNum: 'A12-004',
        title: '종횡단면도',
        scale: '400',
        localPath: 'asset/photos/A12-004.png',
      ),
    ];
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  void dispose() {
    super.dispose();
    _pContrl.dispose();
    _gridX.dispose();
    _gridY.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      deviceWidth = MediaQuery.of(context).size.width;
      width = deviceWidth;
      heigh = deviceWidth / (421 / 297);
    });
    return Scaffold(
        appBar: AppBar(title: Text('그리드 버튼')),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('origingrid').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SafeArea(child: Center(child: CircularProgressIndicator()));
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          key: _key,
                          aspectRatio: 421 / 297,
                          child: ClipRect(
                            child: PhotoView.customChild(
                              minScale: 1.0,
                              initialScale: 1.0,
                              controller: _pContrl,
                              backgroundDecoration: BoxDecoration(color: Colors.transparent),
                              child: Stack(
                                children: [
                                  PositionedTapDetector(
                                    onLongPress: (m) {
                                      ///TODO 원점 재지정 좌표 메서드
                                      // setState(() {
                                      //   context.read<Current>().getDrawing().originX =
                                      //       (m.relative.dx / (width * _pContrl.scale)) -
                                      //           (realIntersect.dx / context.read<Current>().getcordiX());
                                      //   context.read<Current>().getDrawing().originY =
                                      //       (m.relative.dy / (heigh * _pContrl.scale)) -
                                      //           (realIntersect.dy / context.read<Current>().getcordiY());
                                      //   print(
                                      //       '${context.read<Current>().getDrawing().originX}, ${context.read<Current>().getDrawing().originY}');
                                      // });
                                    },
                                    onTap: (m) {
                                      List<Point<double>> parseList = _iPs
                                          .map((e) =>
                                              Point(e.dx, e.dy) * deviceWidth +
                                              Point(context.read<Current>().getcordiOffset(width, heigh).dx,
                                                  context.read<Current>().getcordiOffset(width, heigh).dy))
                                          .toList();
                                      List<Point<double>> realParseList =
                                          _realIPs.map((e) => Point(e.dx, e.dy)).toList();

                                      setState(() {
                                        _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
                                        rectPoint =
                                            Closet(selectPoint: Point(_origin.dx, _origin.dy), pointList: parseList)
                                                .minRect(Point(_origin.dx, _origin.dy));
                                        relativeRectPoint = Closet(
                                                selectPoint: Point(
                                                    (((m.relative.dx / _pContrl.scale) / width -
                                                            context.read<Current>().getDrawing().originX) *
                                                        context.read<Current>().getcordiX()),
                                                    (((m.relative.dy / _pContrl.scale) / heigh -
                                                            context.read<Current>().getDrawing().originY) *
                                                        context.read<Current>().getcordiY())),
                                                pointList: realParseList)
                                            .minRect(Point(
                                                (((m.relative.dx / _pContrl.scale) / width -
                                                        context.read<Current>().getDrawing().originX) *
                                                    context.read<Current>().getcordiX()),
                                                (((m.relative.dy / _pContrl.scale) / heigh -
                                                        context.read<Current>().getDrawing().originY) *
                                                    context.read<Current>().getcordiY())));
                                        print(m.relative / _pContrl.scale);
                                        int debugX = (((m.relative.dx / _pContrl.scale) / width -
                                                    context.read<Current>().getDrawing().originX) *
                                                context.read<Current>().getcordiX())
                                            .round();
                                        int debugY = (((m.relative.dy / _pContrl.scale) / heigh -
                                                    context.read<Current>().getDrawing().originY) *
                                                context.read<Current>().getcordiY())
                                            .round();
                                        print(' 선택한점은 절대좌표 X: $debugX, Y: $debugY');
                                      });
                                    },
                                    child: Stack(
                                      key: _key2,
                                      children: [
                                        Image.asset(context.watch<Current>().getDrawing().localPath),
                                        Container(
                                          child: CustomPaint(
                                            painter: GridMaker(
                                              snapshot.data.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList(),
                                              double.parse(context.watch<Current>().getDrawing().scale) * 421,
                                              _origin,
                                              pointList: _iPs,
                                              deviceWidth: deviceWidth,
                                              cordinate: context.watch<Current>().getcordiOffset(width, heigh),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ...tasks.map(
                                    (e) {
                                      var pro = context.watch<Current>();
                                      return Positioned.fromRect(
                                        rect: Rect.fromPoints(
                                            Offset(
                                              e.boundary.bottomRight.dx / (pro.getcordiX() / width) +
                                                  (pro.getDrawing().originX * width),
                                              e.boundary.bottomRight.dy / (pro.getcordiY() / heigh) +
                                                  ((pro.getDrawing().originY * heigh)),
                                            ),
                                            Offset(
                                              e.boundary.topLeft.dx / (pro.getcordiX() / width) +
                                                  (pro.getDrawing().originX * width),
                                              e.boundary.topLeft.dy / (pro.getcordiY() / heigh) +
                                                  ((pro.getDrawing().originY * heigh)),
                                            )),
                                        child: Opacity(
                                          opacity: 0.8,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              print(e.writeTime.toString());
                                            },
                                            child: null,
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _gridX,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'X그리드',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _gridY,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Y그리드',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text('선택 교점 $selectIntersect', textScaleFactor: 2),
                          Text('좌표 교점 $realIntersect', textScaleFactor: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    autofocus: true,
                                    onPressed: () {
                                      setState(() {
                                        reaSelectIntersect();
                                      });
                                    },
                                    child: Text('원점지정'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        context.read<Current>().changePath(drawings[0]);
                                        recaculate();
                                        //TODO 원점 비율 * 위젯의 사이즈
                                      });
                                    },
                                    child: Text('1층 평면도'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          context.read<Current>().changePath(drawings[1]);
                                          recaculate();
                                        });
                                      },
                                      child: Text('1층 확대 평면도')),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          context.read<Current>().changePath(drawings[2]);
                                          recaculate();
                                        });
                                      },
                                      child: Text('1층 확대 평면도2')),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {});
                                      },
                                      child: Text('단면도')),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        var _wTime = DateTime.now();
                                        tasks.add(Task(_wTime,
                                            boundary: Rect.fromPoints(
                                                Offset(relativeRectPoint.first.x, relativeRectPoint.first.y),
                                                Offset(relativeRectPoint.last.x, relativeRectPoint.last.y))));
                                      });
                                    },
                                    child: Text('Task 추가'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() async {
                                        FirebaseFirestore _db = FirebaseFirestore.instance;
                                        CollectionReference dbGrid = _db.collection('tasks');
                                        dbGrid.doc(tasks.last.writeTime.toString()).set(tasks[0].toJson());
                                      });
                                    },
                                    child: Text('서버데이터 추가'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  void reaSelectIntersect() {
    double _scale = double.parse(context.read<Current>().getDrawing().scale) * 421.0;
    testgrids.where((e) => e.name == _gridX.text || e.name == _gridY.text).forEach((element) {
      print(element.name);
    });
    List<Gridtestmodel> selectGrid = testgrids.where((e) => e.name == _gridX.text || e.name == _gridY.text).toList();
    Line i = Line(Offset(selectGrid.first.startX.toDouble(), -selectGrid.first.startY.toDouble()),
        Offset(selectGrid.first.endX.toDouble(), -selectGrid.first.endY.toDouble()));
    Line j = Line(Offset(selectGrid.last.startX.toDouble(), -selectGrid.last.startY.toDouble()),
        Offset(selectGrid.last.endX.toDouble(), -selectGrid.last.endY.toDouble()));
    selectIntersect = Intersection().compute(i, j) / _scale * deviceWidth;
    realIntersect = Intersection().compute(i, j);
  }

  void recaculate() {
    List<Line> lines = [];
    double _scale = double.parse(context.read<Current>().getDrawing().scale) * 421.0;
    testgrids.forEach((e) {
      lines.add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble()) / _scale,
          Offset(e.endX.toDouble(), -e.endY.toDouble()) / _scale));
    });
    _iPs = Intersection().computeLines(lines).toSet().toList();
    List<Line> realLines = [];
    testgrids.forEach((e) {
      realLines
          .add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble()), Offset(e.endX.toDouble(), -e.endY.toDouble())));
    });
    _realIPs = Intersection().computeLines(realLines).toSet().toList();
  }
}
