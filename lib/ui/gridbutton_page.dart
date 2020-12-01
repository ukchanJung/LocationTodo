import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/closest_model.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
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
  List<Gridtestmodel> testgrids = [];
  Offset _origin = Offset(0, 0);
  //TODO 도면의 스케일 값을 지정해줘야됨
  double gScale = 421.0*500;
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
  Offset corinatePoint = Offset(0,0);
  Offset selectIntersect = Offset(0,0);

  @override
  void initState() {
    super.initState();

    void readingGrid() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('gridTest').get();
      testgrids = read.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList();
      //그리드를 통한 교차점 확인
      List<Line> lines = [];
      testgrids.forEach((e) {
        lines.add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble())/gScale, Offset(e.endX.toDouble(), -e.endY.toDouble())/gScale ));
      });
      _iPs = Intersection().computeLines(lines).toSet().toList();
      _iPs.forEach((element) {print(element.toString());});

    }

    readingGrid();
  }
  @override
  void didChangeDependencies() async{
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
                    lines.add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble())/gScale, Offset(e.endX.toDouble(), -e.endY.toDouble())/gScale ));
                  });
                  _iPs = Intersection().computeLines(lines).toSet().toList();
                  _iPs.forEach((element) {print(element.toString());});
                  // RenderBox _containerBox = _key.currentContext.findRenderObject();
                  // Size containerSize = _containerBox.size;
                  // print(containerSize);
                  // print(MediaQuery.of(context).size);
                  // print(MediaQuery.of(context).devicePixelRatio);
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
                                    onLongPress: (m){
                                      setState(() {
                                        corinatePoint = Offset(m.relative.dx, m.relative.dy) / _photoViewController.scale -selectIntersect;
                                        // print(corinatePoint);
                                        print(m.relative/_photoViewController.scale);
                                      });
                                    },
                                    onTap: (m) {
                                      List<Point<double>> parseList = _iPs.map((e) => Point(e.dx, e.dy)*deviceWidth+Point(corinatePoint.dx, corinatePoint.dy)).toList();
                                      setState(() {
                                        _origin = Offset(m.relative.dx, m.relative.dy) / _photoViewController.scale;
                                        rectPoint = Closet(selectPoint: Point(_origin.dx, _origin.dy), pointList: parseList).minRect(Point(_origin.dx, _origin.dy));
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Image.asset(path),
                                        Container(
                                          child: CustomPaint(
                                            painter: GridMaker(snapshot.data.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList(), gScale, _origin, pointList: _iPs ,deviceWidth: deviceWidth,cordinate: corinatePoint),
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
                    Text('선택 교점$selectIntersect',textScaleFactor: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  testgrids.where((e) => e.name==_gridX.text||e.name==_gridY.text).forEach((element) {print(element.name);});
                                  var selectGrid = testgrids.where((e) => e.name==_gridX.text||e.name==_gridY.text).toList();
                                  Line i = Line(Offset(selectGrid.first.startX.toDouble(),-selectGrid.first.startY.toDouble()),Offset(selectGrid.first.endX.toDouble(),-selectGrid.first.endY.toDouble()));
                                  Line j = Line(Offset(selectGrid.last.startX.toDouble(),-selectGrid.last.startY.toDouble()),Offset(selectGrid.last.endX.toDouble(),-selectGrid.last.endY.toDouble()));
                                  selectIntersect=Intersection().compute(i,j)/gScale*deviceWidth;
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
                                  gScale = 421*docScale;
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
                                    gScale = 421*docScale;
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
                                  tasks.add(Task(_wTime, boundary: Rect.fromPoints(Offset(rectPoint.first.x, rectPoint.first.y), Offset(rectPoint.last.x, rectPoint.last.y))));
                                });
                              },
                              child: Text('Task 추가'),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: ElevatedButton(
                        //       onPressed: () {
                        //           FirebaseFirestore _db = FirebaseFirestore.instance;
                        //           CollectionReference dbGrid = _db.collection('gridTest');
                        //           List dd = [{'name':'Y-0','type':'Y','index':'0','startX':26000,'startY':-109600,'endX':164500,'endY':-109600},
                        //             {'name':'Y-1','type':'Y','index':'1','startX':26000,'startY':-104300,'endX':131200,'endY':-104300},
                        //             {'name':'Y-2','type':'Y','index':'2','startX':26000,'startY':-96200,'endX':131200,'endY':-96200},
                        //             {'name':'Y-3','type':'Y','index':'3','startX':26000,'startY':-89000,'endX':68970,'endY':-89000},
                        //             {'name':'Y-4','type':'Y','index':'4','startX':26000,'startY':-83000,'endX':68970,'endY':-83000},
                        //             {'name':'Y-5','type':'Y','index':'5','startX':26000,'startY':-77150,'endX':68970,'endY':-77150},
                        //             {'name':'Y-6','type':'Y','index':'6','startX':26000,'startY':-71150,'endX':68970,'endY':-71150},
                        //             {'name':'Y-7','type':'Y','index':'7','startX':26000,'startY':-65150,'endX':68970,'endY':-65150},
                        //             {'name':'Y-8','type':'Y','index':'8','startX':26000,'startY':-59300,'endX':68970,'endY':-59300},
                        //             {'name':'Y-9','type':'Y','index':'9','startX':26000,'startY':-53000,'endX':89000,'endY':-53000},
                        //             {'name':'Y-10','type':'Y','index':'10','startX':26000,'startY':-45800,'endX':89000,'endY':-45800},
                        //             {'name':'Y-11','type':'Y','index':'11','startX':26000,'startY':-38000,'endX':89000,'endY':-38000},
                        //             {'name':'Y-0a','type':'Y','index':'0a','startX':131200,'startY':-104450,'endX':164500,'endY':-104450},
                        //             {'name':'Y-10a','type':'Y','index':'10a','startX':89000,'startY':-45150,'endX':164500,'endY':-45150},
                        //             {'name':'Y-11a','type':'Y','index':'11a','startX':89000,'startY':-37850,'endX':164500,'endY':-37850},
                        //             {'name':'Y-1a','type':'Y','index':'1a','startX':131200,'startY':-97150,'endX':164500,'endY':-97150},
                        //             {'name':'Y-2a','type':'Y','index':'2a','startX':131200,'startY':-89850,'endX':164500,'endY':-89850},
                        //             {'name':'Y-4a','type':'Y','index':'4a','startX':73500,'startY':-81400,'endX':164500,'endY':-81400},
                        //             {'name':'Y-5a','type':'Y','index':'5a','startX':73500,'startY':-76900,'endX':164500,'endY':-76900},
                        //             {'name':'Y-6a','type':'Y','index':'6a','startX':88500,'startY':-69800,'endX':164500,'endY':-69800},
                        //             {'name':'Y-7a','type':'Y','index':'7a','startX':73500,'startY':-60900,'endX':164500,'endY':-60900},
                        //             {'name':'Y-9a','type':'Y','index':'9a','startX':89000,'startY':-52450,'endX':164500,'endY':-52450},
                        //             {'name':'X-1','type':'X','index':'1','startX':47000,'startY':-22000,'endX':47000,'endY':-117700},
                        //             {'name':'X-2','type':'X','index':'2','startX':54500,'startY':-22000,'endX':54500,'endY':-117700},
                        //             {'name':'X-3','type':'X','index':'3','startX':60500,'startY':-22000,'endX':60500,'endY':-117700},
                        //             {'name':'X-4','type':'X','index':'4','startX':66500,'startY':-22000,'endX':66500,'endY':-117700},
                        //             {'name':'X-5','type':'X','index':'5','startX':75500,'startY':-22000,'endX':75500,'endY':-117700},
                        //             {'name':'X-6','type':'X','index':'6','startX':84500,'startY':-22000,'endX':84500,'endY':-55000},
                        //             {'name':'X-7','type':'X','index':'7','startX':93500,'startY':-22000,'endX':93500,'endY':-55000},
                        //             {'name':'X-8','type':'X','index':'8','startX':99500,'startY':-22000,'endX':99500,'endY':-55000},
                        //             {'name':'X-9','type':'X','index':'9','startX':108500,'startY':-22000,'endX':108500,'endY':-117700},
                        //             {'name':'X-10','type':'X','index':'10','startX':117500,'startY':-22000,'endX':117500,'endY':-55000},
                        //             {'name':'X-11','type':'X','index':'11','startX':123500,'startY':-22000,'endX':123500,'endY':-84400},
                        //             {'name':'X-12','type':'X','index':'12','startX':132900,'startY':-22000,'endX':132900,'endY':-117700},
                        //             {'name':'X-13','type':'X','index':'13','startX':138200,'startY':-22000,'endX':138200,'endY':-117700},
                        //             {'name':'X-14','type':'X','index':'14','startX':143600,'startY':-22000,'endX':143600,'endY':-117700},
                        //             {'name':'X-15','type':'X','index':'15','startX':150550,'startY':-22000,'endX':150550,'endY':-117700},
                        //             {'name':'X-10a','type':'X','index':'10a','startX':120500,'startY':-88000,'endX':120500,'endY':-117700},
                        //             {'name':'X-11a','type':'X','index':'11a','startX':129500,'startY':-88000,'endX':129500,'endY':-117700},
                        //             {'name':'X-14a','type':'X','index':'14a','startX':147800,'startY':-58000,'endX':147800,'endY':-117700},
                        //             {'name':'X-15a','type':'X','index':'15a','startX':152500,'startY':-22000,'endX':152500,'endY':-117700},
                        //             {'name':'X-5a','type':'X','index':'5a','startX':81500,'startY':-58000,'endX':81500,'endY':-117700},
                        //             {'name':'X-6a','type':'X','index':'6a','startX':90500,'startY':-58000,'endX':90500,'endY':-117700},
                        //             {'name':'X-7a','type':'X','index':'7a','startX':96500,'startY':-58000,'endX':96500,'endY':-117700},
                        //             {'name':'X-8a','type':'X','index':'8a','startX':102500,'startY':-58000,'endX':102500,'endY':-117700},
                        //             {'name':'X-9a','type':'X','index':'9a','startX':114500,'startY':-58000,'endX':114500,'endY':-117700},];
                        //           // dbGrid.add({'name':'Y-0','type':'Y','index':'0','startX':26000,'startY':-109600,'endX':164500,'endY':-109600},);
                        //           dd.forEach((e) {dbGrid.add(e);});
                        //       },
                        //       child: Text('서버그리드 추가'),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
