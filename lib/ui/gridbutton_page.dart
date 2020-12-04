import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/closest_model.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

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
  double docScale = 500;
  TextEditingController _gridX = TextEditingController();
  TextEditingController _gridY = TextEditingController();
  String dropdownValue = 'One';
  Grid select;
  List<Offset> _iPs;
  List<Point> rectPoint = [];
  List<Point> relativeRectPoint = [];
  QuerySnapshot read;
  List<Task> tasks = [];
  List<Task> relativeasks = [];
  PhotoViewController _photoViewController = PhotoViewController();
  final GlobalKey _key = GlobalKey();
  final GlobalKey _key2 = GlobalKey();
  double deviceWidth;

  String path = 'asset/Plan2.png';
  Offset corinatePoint = Offset(754.5, 167.1);
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
      ),
      Drawing(
        drawingNum: 'A31-109',
        title: '1층 확대 평면도',
        scale: '200',
        localPath: 'asset/photos/A31-109.png',
        originX: 0.1640856576345598,
        originY: 0.17141887724960456,
      ),
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
    _photoViewController.dispose();
    _gridX.dispose();
    _gridY.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      deviceWidth = MediaQuery.of(context).size.width;
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
                              controller: _photoViewController,
                              backgroundDecoration: BoxDecoration(color: Colors.transparent),
                              child: Stack(
                                children: [
                                  PositionedTapDetector(
                                    onLongPress: (m) {
                                      setState(() {
                                        corinatePoint =
                                            Offset(m.relative.dx, m.relative.dy) / _photoViewController.scale -
                                                selectIntersect;
                                        num width2 = _key2.currentContext.size.width;
                                        num heigh2 = _key2.currentContext.size.height;
                                        drawings[0].originX = m.relative.dx / (width2 * _photoViewController.scale);
                                        drawings[0].originY = m.relative.dy / (heigh2 * _photoViewController.scale);
                                        print(m.relative / _photoViewController.scale);
                                        print('${drawings[0].originX}, ${drawings[0].originY}');
                                      });
                                    },
                                    onTap: (m) {
                                      List<Point<double>> parseList = _iPs
                                          .map((e) =>
                                              Point(e.dx, e.dy) * deviceWidth +
                                              Point(corinatePoint.dx, corinatePoint.dy))
                                          .toList();
                                      setState(() {
                                        _origin = Offset(m.relative.dx, m.relative.dy) / _photoViewController.scale;
                                        rectPoint =
                                            Closet(selectPoint: Point(_origin.dx, _origin.dy), pointList: parseList)
                                                .minRect(Point(_origin.dx, _origin.dy));
                                        relativeRectPoint =
                                            Closet(selectPoint: Point(_origin.dx, _origin.dy), pointList: parseList)
                                                .minRect(Point(_origin.dx, _origin.dy));
                                        num width2 = _key2.currentContext.size.width;
                                        num heigh2 = _key2.currentContext.size.height;
                                        print(
                                            'X: ${(((m.relative.dx / _photoViewController.scale) / width2 - 0.7373979439768359) * 421 * 200).round()}, Y: ${(((m.relative.dy / _photoViewController.scale) / heigh2 - 0.23113260932198965) * 297 * 200).round()}');
                                      });
                                    },
                                    child: Stack(
                                      key: _key2,
                                      children: [
                                        Image.asset(path),
                                        Container(
                                          child: CustomPaint(
                                            painter: GridMaker(
                                                snapshot.data.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList(),
                                                gScale,
                                                _origin,
                                                pointList: _iPs,
                                                deviceWidth: deviceWidth,
                                                cordinate: corinatePoint),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...tasks.map(
                                    (e) => Positioned.fromRect(
                                      rect: e.boundary,
                                      child: Opacity(
                                        opacity: 0.8,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            print(e.writeTime.toString());
                                          },
                                          child: null,
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(0.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
                          Text(
                            '선택 교점 $selectIntersect',
                            textScaleFactor: 2,
                          ),
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
                                        num width2 = _key2.currentContext.size.width;
                                        num heigh2 = _key2.currentContext.size.height;
                                        path = drawings[0].localPath;
                                        docScale = double.parse(drawings[0].scale);
                                        gScale = 421 * docScale;
                                        recaculate();
                                        reaSelectIntersect();
                                        corinatePoint =
                                            Offset(drawings[0].originX * 1024, drawings[0].originY * heigh2);
                                        // originX: 0.7373979439768359,
                                        // originY: 0.23113260932198965,
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
                                          path = drawings[1].localPath;
                                          docScale = double.parse(drawings[1].scale);
                                          gScale = 421 * docScale;
                                          recaculate();
                                          reaSelectIntersect();
                                          corinatePoint = Offset(168.9, 124.4) - selectIntersect;
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
                                          path = drawings[2].localPath;
                                          docScale = num.parse(drawings[2].scale);
                                        });
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
                                            boundary: Rect.fromPoints(Offset(rectPoint.first.x, rectPoint.first.y),
                                                Offset(rectPoint.last.x, rectPoint.last.y))));
                                        relativeasks.add(Task(_wTime,
                                            boundary: Rect.fromPoints(Offset(rectPoint.first.x, rectPoint.first.y),
                                                Offset(rectPoint.last.x, rectPoint.last.y))));
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
    testgrids.where((e) => e.name == _gridX.text || e.name == _gridY.text).forEach((element) {
      print(element.name);
    });
    List<Gridtestmodel> selectGrid = testgrids.where((e) => e.name == _gridX.text || e.name == _gridY.text).toList();
    Line i = Line(Offset(selectGrid.first.startX.toDouble(), -selectGrid.first.startY.toDouble()),
        Offset(selectGrid.first.endX.toDouble(), -selectGrid.first.endY.toDouble()));
    Line j = Line(Offset(selectGrid.last.startX.toDouble(), -selectGrid.last.startY.toDouble()),
        Offset(selectGrid.last.endX.toDouble(), -selectGrid.last.endY.toDouble()));
    selectIntersect = Intersection().compute(i, j) / gScale * deviceWidth;
  }

  void recaculate() {
    List<Line> lines = [];
    testgrids.forEach((e) {
      lines.add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble()) / gScale,
          Offset(e.endX.toDouble(), -e.endY.toDouble()) / gScale));
    });
    _iPs = Intersection().computeLines(lines).toSet().toList();
  }
}
