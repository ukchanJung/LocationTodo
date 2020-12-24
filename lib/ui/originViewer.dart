import 'dart:io';
import 'dart:ui' as ui show Codec, FrameInfo, Image;
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/boundary_model.dart';
import 'package:flutter_app_location_todo/model/closest_model.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';
import 'package:flutter_app_location_todo/model/room_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';

class originView extends StatefulWidget {
  @override
  _originViewState createState() => _originViewState();
}

class _originViewState extends State<originView> {
  VisionText visionText;
  GlobalKey _keyA = GlobalKey();
  PhotoViewController _pContrl;
  double iS;
  ui.Image decodeImage;
  List<Drawing> drawings;
  Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
  List<Drawing> favoriteds = [];
  OcrCategory _ocrCategory = OcrCategory.Room;
  TextEditingController field0 = TextEditingController();
  TextEditingController field1 = TextEditingController();
  TextEditingController field2 = TextEditingController();
  TextEditingController field3 = TextEditingController();
  TextEditingController field4 = TextEditingController();

  List<Gridtestmodel> testgrids = [];
  double deviceWidth;
  num width;
  num heigh;
  List<Offset> _realIPs;
  Offset _origin = Offset(0, 0);
  int debugX;
  int debugY;
  List<Point> relativeRectPoint;

  Rect selectRect;
  List<bool> ocrFinList = [];
  double sLeft;
  double sTop;
  double sRight;
  double sBottom;
  int rLeft;
  int rTop;
  int rRight;
  int rBottom;
  bool sCheck = false;
  bool ocrLayer = true;
  List<Offset> tracking = [];
  List<int> count = [];
  String filter = 'A';
  int selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pContrl = PhotoViewController();

    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
    });

    void readingGrid() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('origingrid').get();
      testgrids = read.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList();
      //그리드를 통한 교차점 확인
      recaculate();
      //TODO 실시간 연동 바운더리
    }

    readingGrid();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pContrl.dispose();
    field0.dispose();
    field1.dispose();
    field2.dispose();
    field3.dispose();
    field4.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      deviceWidth = MediaQuery.of(context).size.width;
      width = deviceWidth;
      heigh = deviceWidth / (421 / 297);
    });
    return Scaffold(
      endDrawer: Drawer(
          child: drawings == null
              ? Container()
              : Scrollbar(
                  child: ListView(
                    children: drawings
                        .map((e) => ListTile(
                              title: Text(e.toString()),
                              onTap: () {
                                setState(() async {
                                  context.read<Current>().changePath(e);
                                  iS = decodeImage.width / _keyA.currentContext.size.width;
                                  tracking = [];
                                  count = [];
                                  setState(() {});
                                });
                              },
                            ))
                        .toList(),
                  ),
                )),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                tracking = [];
                count = [];
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 40,
          ),
          Divider(),
          Listener(
            onPointerSignal: (m){
              if(m is PointerScrollEvent) {
                if(m.scrollDelta.dy>1){
                  _pContrl.scale = _pContrl.scale +0.2;
                }else{
                  _pContrl.scale = _pContrl.scale -0.2;
                }
                print(m.scrollDelta);
              };
            },
            child: AspectRatio(
              aspectRatio: 421 / 297,
              child: ClipRect(
                child: Container(
                  child: PhotoView.customChild(
                    key: _keyA,
                    controller: _pContrl,
                    minScale: 1.0,
                    maxScale: 10.0,
                    backgroundDecoration: BoxDecoration(color: Colors.transparent),
                    child: PositionedTapDetector(
                      onTap: (m) {
                        setState(
                          () {
                            _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
                            tracking.add(_origin);
                            count.add(tracking.length);
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                          StreamBuilder<PhotoViewControllerValue>(
                            stream: _pContrl.outputStateStream,
                            builder: (context, snapshot) {
                              return Stack(
                                children: [
                                  CustomPaint(
                                    painter: CallOutBoundary(
                                        setPoint: _origin, left: sLeft, top: sTop, right: sRight, bottom: sBottom, tP: tracking,s: snapshot.data.scale),
                                  ),
                                  count != []
                                      ? Stack(
                                    children: count
                                        .map((e) => Positioned.fromRect(
                                        rect: Rect.fromCenter(
                                            center: tracking[count.indexOf(e)], width: 100, height: 100),
                                        child: Center(
                                            child: Text(
                                              e.toString(),
                                              style: TextStyle(color: Colors.white),
                                              textScaleFactor: 1/snapshot.data.scale,
                                            ))))
                                        .toList(),
                                  )
                                      : Container(),
                                ],
                              );
                            }
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Card(
                          child: ListTile(
                        title: Text('프로젝트1'),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('프로젝트2'),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('프로젝트3'),
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Card(
                          child: ListTile(
                        title: Text('2020.12.01'),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('2020.09.15'),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('2020.05.31'),
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Card(
                        child: ListTile(
                          selected: selected ==0,
                          title: Text('건축'),
                          onTap: () {
                            setState(() {
                              filter = 'A';
                              selected = 0;
                            });
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text('구조'),
                          selected: selected ==1,
                          onTap: () {
                            setState(() {
                              filter = 'S';
                              selected =1;
                            });
                          },
                        ),
                      ),
                      Card(
                          child: ListTile(
                            selected: selected ==2,
                            onTap: () {
                              setState(() {
                                filter = 't';
                                selected =2;
                              });
                            },
                        title: Text('설비'),
                      )),
                      Card(
                          child: ListTile(
                            selected: selected ==3,
                            onTap: () {
                              setState(() {
                                filter = 't';
                                selected =3;
                              });
                            },
                        title: Text('설비'),
                      )),
                      Card(
                          child: ListTile(
                            selected: selected ==4,
                            onTap: () {
                              setState(() {
                                filter = 't';
                                selected =4;
                              });
                            },
                        title: Text('전기'),
                      )),
                      Card(
                          child: ListTile(
                            selected: selected ==5,
                            onTap: () {
                              setState(() {
                                filter = 't';
                               selected =5;
                              });
                            },
                        title: Text('토목'),
                      )),
                      Card(
                          child: ListTile(
                            selected: selected ==6,
                            onTap: () {
                              setState(() {
                                filter = 't';
                                selected =6;
                              });
                            },
                        title: Text('조경'),
                      )),
                      Card(
                          child: ListTile(
                            selected: selected ==7,
                            onTap: () {
                              setState(() {
                                filter = 't';
                                selected =7;
                              });
                            },
                        title: Text('소방'),
                      )),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Scrollbar(
                    // isAlwaysShown: true,
                    thickness: 10,
                    child: ListView(
                      children: drawings
                          .where((element) => element.listCategory.startsWith(filter))
                          .map((e) => Card(
                                  child: ListTile(
                                title: Text(e.toString()),
                                  onTap: () {
                                      count = [];
                                      tracking = [];
                                    setState(() async {
                                      context.read<Current>().changePath(e);
                                      iS = decodeImage.width / _keyA.currentContext.size.width;
                                    });
                                  })))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void recaculate() {
    List<Line> realLines = [];
    testgrids.forEach((e) {
      realLines
          .add(Line(Offset(e.startX.toDouble(), -e.startY.toDouble()), Offset(e.endX.toDouble(), -e.endY.toDouble())));
    });
    _realIPs = Intersection().computeLines(realLines).toSet().toList();
  }
}

Future<List<Drawing>> getData(filter) async {
  var response = await Dio().get(
    "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
    queryParameters: {"filter": filter},
  );

  var models = Drawing.fromJsonList(response.data);
  return models;
}

class CallOutBoundary extends CustomPainter {
  Offset setPoint;
  double top;
  double bottom;
  double left;
  double right;
  List<Offset> tP;
  double s=1;

  CallOutBoundary({this.left, this.top, this.right, this.bottom, this.setPoint, this.tP,this.s});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 2.0
      ..color = Color.fromRGBO(0, 0, 255, 0.5);
    Paint paint2 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..color = Color.fromRGBO(255, 0, 0, 0.6);
    Paint paint4 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25.0/s
      ..color = Color.fromRGBO(255, 0, 0, 1);
    Paint paint5 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0/s
      ..color = Color.fromRGBO(255, 0, 0, 1);

    left == null && top == null && right == null && bottom == null
        ? null
        : canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    setPoint == null ? null : canvas.drawPoints(PointMode.points, [setPoint], paint2);
    setPoint == null ? null : canvas.drawPoints(PointMode.points, tP, paint4);
    setPoint == null ? null : canvas.drawPoints(PointMode.polygon, tP, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

