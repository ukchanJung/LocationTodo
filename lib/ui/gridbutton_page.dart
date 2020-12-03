import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/closest_model.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

void write() async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference dbGrid = _db.collection('gridList');
  dbGrid.doc('test').set({
    'name': 'X1',
    'x': 7500.0,
  });
}

void writeX(String name, num cordinate) async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference dbGrid = _db.collection('gridList');
  dbGrid.doc(name).set({
    'name': name,
    'x': cordinate,
  });
}

void writeY(String name, num cordinate) async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = _db.collection('gridList');
  dbGrid.doc(name).set({
    'name': name,
    'y': cordinate,
  });
}

void updateX(String name, num cordinate) async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = _db.collection('gridList');
  dbGrid.doc(name).update({
    'name': name,
    'x': cordinate,
  });
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
  QuerySnapshot read;
  List<Task> tasks = [];
  PhotoViewController _photoViewController = PhotoViewController();
  final GlobalKey _key = GlobalKey();
  double deviceWidth;

  String path = 'asset/Plan2.png';
  Offset corinatePoint = Offset(0, 0);
  Offset selectIntersect = Offset(0, 0);

  @override
  void initState() {
    super.initState();

    void readingGrid() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('gridTest').get();
      testgrids = read.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList();
      //그리드를 통한 교차점 확인
      List<Line> lines = [];
      testgrids.forEach(
        (e) {
          lines.add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble()) / gScale,
              Offset(e.endX.toDouble(), -e.endY.toDouble()) / gScale));
        },
      );
      _iPs = Intersection().computeLines(lines).toSet().toList();
      _iPs.forEach((element) {
        print(element.toString());
      });
    }

    readingGrid();
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
        appBar: AppBar(
          title: Text('그리드 버튼'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  List<Line> lines = [];
                  testgrids.forEach((e) {
                    lines.add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble()) / gScale,
                        Offset(e.endX.toDouble(), -e.endY.toDouble()) / gScale));
                  });
                  _iPs = Intersection().computeLines(lines).toSet().toList();
                  _iPs.forEach((element) {
                    print(element.toString());
                  });
                  // RenderBox _containerBox = _key.currentContext.findRenderObject();
                  // Size containerSize = _containerBox.size;
                  // print(containerSize);
                }),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('gridTest').snapshots(),
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
                          aspectRatio: 1,
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
                                        // print(corinatePoint);
                                        print(m.relative / _photoViewController.scale);
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
                                      });
                                    },
                                    child: Stack(
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
                    // Expanded(
                    //   child: ListView(children: snapshot.data.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList().map((e) => Text('${e.name}은' '${e.startX}' '${e.endY}')).toList()
                    //       // children: grids.map((e) => Text('${e.name}은''${e.x}''${e.y}')).toList()
                    //       ),
                    // ),
                    // Card(
                    //   elevation: 4,
                    //   child: ListTile(
                    //     title: select == null ? Text('그리드를 선택해주세요') : Text(select.toString()),
                    //     onTap: () async {
                    //       Grid _select;
                    //       _select = await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => GridList(snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList())),
                    //       );
                    //       setState(() {
                    //         select = _select;
                    //       });
                    //     },
                    //   ),
                    // ),
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
                      '선택 교점$selectIntersect',
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
                                  testgrids
                                      .where((e) => e.name == _gridX.text || e.name == _gridY.text)
                                      .forEach((element) {
                                    print(element.name);
                                  });
                                  var selectGrid =
                                      testgrids.where((e) => e.name == _gridX.text || e.name == _gridY.text).toList();
                                  Line i = Line(
                                      Offset(selectGrid.first.startX.toDouble(), -selectGrid.first.startY.toDouble()),
                                      Offset(selectGrid.first.endX.toDouble(), -selectGrid.first.endY.toDouble()));
                                  Line j = Line(
                                      Offset(selectGrid.last.startX.toDouble(), -selectGrid.last.startY.toDouble()),
                                      Offset(selectGrid.last.endX.toDouble(), -selectGrid.last.endY.toDouble()));
                                  selectIntersect = Intersection().compute(i, j) / gScale * deviceWidth;
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
                                  path = 'asset/Plan2.png';
                                  docScale = 500;
                                  gScale = 421 * docScale;
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
                                    path = 'asset/photos/A31-109.png';
                                    docScale = 200;
                                    gScale = 421 * docScale;
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
                                    path = 'asset/photos/A12-004.png';
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
                                  CollectionReference dbGrid2 = _db.collection('origingrid');
                                  // dbGrid.doc('테스트').set(tasks[0].toJson());

                                  QuerySnapshot read = await _db.collection('gridTest').get();
                                  List<Gridtestmodel> tempLines =
                                      read.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList();

                                  tempLines.forEach((e) {
                                    e.startX = e.startX - 154900;
                                    e.startY = e.startY + 34000;
                                    e.endX = e.endX - 154900;
                                    e.endY = e.endY + 34000;
                                  });
                                  print(tempLines);
                                });
                              },
                              child: Text('서버데이터 추가'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore _db = FirebaseFirestore.instance;
                                CollectionReference dbGrid2 = _db.collection('origingrid');
                                testgrids.forEach((e) => dbGrid2.doc(e.name).update({
                                      'endX': e.endX - 154900,
                                      'endY': e.endY + 34000,
                                      'index': e.index,
                                      'name': e.name,
                                      'startX': e.startX - 154900,
                                      'startY': e.startY + 34000,
                                      'type': e.type,
                                    }));
                              },
                              child: Icon(Icons.add)),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
