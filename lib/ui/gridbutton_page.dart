import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/closest_model.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/intersection_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/ui/gridlist_page.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

void write() async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = await _db.collection('gridList');
  dbGrid.doc('test').set({
    'name': 'X1',
    'x': 7500.0,
  });
}

void writeX(String name, num cordinate) async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = await _db.collection('gridList');
  dbGrid.doc(name).set({
    'name': name,
    'x': cordinate,
  });
}

void writeY(String name, num cordinate) async {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // QuerySnapshot read = await _db.collection('gridList').get();
  CollectionReference dbGrid = await _db.collection('gridList');
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
  Offset _origin = Offset(0, 0);
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _distanceControl = TextEditingController();
  String dropdownValue = 'One';
  Grid select;
  List<Offset> _iPs;
  List<Point> rectPoint = [];
  QuerySnapshot read;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    // grids.addAll([
    //   Grid('X1',x: 0),
    //   Grid('Y0',y: 0),
    // ]
    // );
    void reading() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('gridList').get();
      grids = read.docs.map((e) => Grid.fromSnapshot(e)).toList();
    }

    reading();
    print(grids);
  }

  void dispose() {
    super.dispose();
    _nameControl.dispose();
    _distanceControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('그리드 버튼'),
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  List<Line> lines = [];
                  double _scale = 250;
                  double _width = 500;
                  double _height = 300;
                  grids.forEach((e) {
                    if (e.name.contains('X')) {
                      lines.add(Line(Offset(e.x.toDouble() / _scale, 0), Offset(e.x.toDouble() / _scale, _height)));
                    } else if (e.name.contains('Y')) {
                      lines.add(Line(Offset(0, e.y.toDouble() / _scale), Offset(_width, e.y.toDouble() / _scale)));
                    }
                  });
                  _iPs = IntersectPoint().Intersections(lines).toSet().toList();

                  print(lines.length);
                  print(_iPs.length);
                },
                icon: Icon(Icons.add),
                label: Text('서버업로드'))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('gridList').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SafeArea(child: Center(child: CircularProgressIndicator()));
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 359,
                            height: 300,
                            child: PositionedTapDetector(
                              onLongPress: (m) {
                                print(m.relative.toString());
                                List<Point<double>> parseList = _iPs.map((e) => Point(e.dx, e.dy)).toList();
                                setState(() {
                                  _origin = Offset(m.relative.dx, m.relative.dy);
                                  rectPoint = Closet(selectPoint: Point(_origin.dx, _origin.dy), pointList: parseList).minRect(Point(_origin.dx, _origin.dy));
                                  print(rectPoint.first);
                                  print(rectPoint.last);
                                });
                              },
                              child: Container(
                                width: 500,
                                height: 300,
                                child: CustomPaint(
                                  painter: GridMaker(snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList(), 250, _origin, pointList: _iPs),
                                ),
                              ),
                            ),
                          ),
                          ...tasks.map((e) =>  Positioned.fromRect(
                            rect: e.boundary,
                            child: Opacity(
                              opacity: 0.5,
                                child: ElevatedButton(onPressed: () {}, child: null)), ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(children: snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList().map((e) => Text('${e.name}은' '${e.x}' '${e.y}')).toList()
                          // children: grids.map((e) => Text('${e.name}은''${e.x}''${e.y}')).toList()
                          ),
                    ),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        title: select == null ? Text('그리드를 선택해주세요') : Text(select.toString()),
                        onTap: () async {
                          Grid _select;
                          _select = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GridList(snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList())),
                          );
                          setState(() {
                            select = _select;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _nameControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '그리드 이름',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _distanceControl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '거리',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            updateX(_nameControl.text, select.x + int.parse(_distanceControl.text));
                            setState(() {
                              select = snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList().firstWhere((e) => e.name.contains(_nameControl.text));
                            });
                          },
                          child: Text('수정하기'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              writeX(_nameControl.text, int.parse(_distanceControl.text));
                              setState(() {
                                select = snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList().firstWhere((e) => e.name.contains(_nameControl.text));
                              });
                            },
                            child: Text('추가하기')),
                        ElevatedButton(
                            onPressed: () {
                              writeY(_nameControl.text, int.parse(_distanceControl.text));
                              setState(() {
                                select = snapshot.data.docs.map((e) => Grid.fromSnapshot(e)).toList().firstWhere((e) => e.name.contains(_nameControl.text));
                              });
                            },
                            child: Text('Y 추가하기')),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {setState(() {
                                var _wTime = DateTime.now();
                                tasks.add(Task(_wTime,boundary: Rect.fromPoints(Offset(rectPoint.first.x,rectPoint.first.y), Offset(rectPoint.last.x,rectPoint.last.y))));
                              });
                              },
                              child: Text('Task 추가'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
