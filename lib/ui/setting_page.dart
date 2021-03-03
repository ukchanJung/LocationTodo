import 'dart:io';
import 'dart:ui' as ui show Codec, FrameInfo, Image;
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/data/grid_data.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';
import 'package:flutter_app_location_todo/model/ocr.dart';
import 'package:flutter_app_location_todo/model/room_model.dart';
import 'package:flutter_app_location_todo/ui/backup_setting_page.dart';
import 'package:flutter_app_location_todo/ui/crosshair_paint.dart';
import 'package:flutter_app_location_todo/ui/grid_setting_page.dart';
import 'package:flutter_app_location_todo/ui/info_setting.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
  TextEditingController field5 = TextEditingController();

  List<Gridtestmodel> testgrids = [];
  double deviceWidth;
  double deviceHeigh;
  num width;
  num heigh;
  List<Offset> _realIPs;
  Offset _origin = Offset(0, 0);
  int debugX;
  int debugY;
  List<Point> relativeRectPoint;
  Rect selectRect;
  List<bool> ocrFinList = [];
  List<OcrData> ocrDatas;
  OcrData ocrGet;
  bool ocrCheck = false;
  double sLeft = 0;
  double sTop = 0;
  double sRight = 0;
  double sBottom = 0;
  Offset s1 = Offset(0, 0);
  Offset s2 = Offset(0, 0);
  int rLeft;
  int rTop;
  int rRight;
  int rBottom;
  bool sCheck = false;
  bool ocrLayer = true;
  bool viewerFocus = true;
  var selectCategory = OcrCategory.Room;

  List<Offset> measurement;
  List<Offset> rmeasurement;
  int _bInt = 0;
  double keyX = 0.0;
  double keyY = 0.0;
  Offset hover = Offset.zero;
  List<Widget> bnb ;

  @override
  void initState() {
    super.initState();
    _pContrl = PhotoViewController();

    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
    });
    void fechGrid(){
      testgrids=gridData.map((e) => Gridtestmodel.map(e)).toList();
    }

    void readingGrid() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('origingrid').get();
      testgrids = read.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList();
      //그리드를 통한 교차점 확인
      recaculate();
      //TODO 실시간 연동 바운더리
    }

    readingGrid();
    void readingOcrData() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('ocrData').get();
      ocrDatas = read.docs.map((e) => OcrData.fromSnapshot(e)).toList();
    }

    // readingOcrData();
    bnb = [
      GridSettingPage(),
      SettingPage2(),
      InfoSetting(),
      // LayoutBuilder(builder: (context, rowC) {
      //   return Column(
      //     children: [
      //       Container(
      //         width: rowC.maxWidth,
      //         height: rowC.maxWidth / (420 / 297),
      //         child: LayoutBuilder(builder: (context, c) {
      //           _pContrl.addIgnorableListener(() {
      //             keyX = _pContrl.value.position.dx / (c.maxWidth * _pContrl.value.scale);
      //             keyY = _pContrl.value.position.dy / (c.maxHeight * _pContrl.value.scale);
      //           });
      //           return Listener(
      //             onPointerSignal: (m) {
      //               if (m is PointerScrollEvent) {
      //                 Offset up = Offset(keyX * c.maxWidth * (_pContrl.scale + 0.2),
      //                     keyY * c.maxHeight * (_pContrl.scale + 0.2));
      //                 Offset dn = Offset(keyX * c.maxWidth * (_pContrl.scale - 0.2),
      //                     keyY * c.maxHeight * (_pContrl.scale - 0.2));
      //                 if (m.scrollDelta.dy > 1 && _pContrl.scale > 1) {
      //                   _pContrl.value = PhotoViewControllerValue(
      //                       position: dn,
      //                       scale: (_pContrl.scale - 0.2),
      //                       rotation: 0,
      //                       rotationFocusPoint: null);
      //                 } else if (m.scrollDelta.dy < 1) {
      //                   _pContrl.value = PhotoViewControllerValue(
      //                       position: up,
      //                       scale: (_pContrl.scale + 0.2),
      //                       rotation: 0,
      //                       rotationFocusPoint: null);
      //                 }
      //               }
      //               ;
      //             },
      //             child: Container(
      //               child: ClipRect(
      //                 child: PhotoView.customChild(
      //                   key: _keyA,
      //                   controller: _pContrl,
      //                   minScale: PhotoViewComputedScale.covered,
      //                   maxScale: 10.0,
      //                   backgroundDecoration: BoxDecoration(color: Colors.transparent),
      //                   child: PositionedTapDetector(
      //                     onTap: (m) {
      //                       viewerFocus = true;
      //                       List<Point<double>> realParseList =
      //                       _realIPs.map((e) => Point(e.dx, e.dy)).toList();
      //                       setState(() {
      //                         _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
      //                         debugX = (((m.relative.dx / _pContrl.scale) / c.maxWidth -
      //                             context.read<Current>().getDrawing().originX) *
      //                             context.read<Current>().getcordiX())
      //                             .round();
      //                         debugY =
      //                             (((m.relative.dy / _pContrl.scale) / (c.maxWidth / (420 / 297)) -
      //                                 context.read<Current>().getDrawing().originY) *
      //                                 context.read<Current>().getcordiY())
      //                                 .round();
      //                         // measurement.add(_origin);
      //                         // rmeasurement.add(Offset(debugX.toDouble(), debugY.toDouble()));
      //                         print(' 선택한점은 절대좌표 X: $debugX, Y: $debugY');
      //                       });
      //                     },
      //                     onLongPress: (m) {
      //                       setState(() {
      //                         // _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
      //                         if (sCheck == false) {
      //                           sLeft = m.relative.dx / _pContrl.scale;
      //                           sTop = m.relative.dy / _pContrl.scale;
      //                           rLeft = (((m.relative.dx / _pContrl.scale) / c.maxWidth -
      //                               context.read<Current>().getDrawing().originX) *
      //                               context.read<Current>().getcordiX())
      //                               .round();
      //                           rTop =
      //                               (((m.relative.dy / _pContrl.scale) / (c.maxWidth / (420 / 297)) -
      //                                   context.read<Current>().getDrawing().originY) *
      //                                   context.read<Current>().getcordiY())
      //                                   .round();
      //                           s1 = Offset(
      //                               (((m.relative.dx / _pContrl.scale) / c.maxWidth -
      //                                   context.read<Current>().getDrawing().originX) *
      //                                   context.read<Current>().getcordiX()),
      //                               (((m.relative.dy / _pContrl.scale) / (c.maxWidth / (420 / 297)) -
      //                                   context.read<Current>().getDrawing().originY) *
      //                                   context.read<Current>().getcordiY()));
      //                           print(s1);
      //                           sCheck = true;
      //                         } else {
      //                           sRight = m.relative.dx / _pContrl.scale;
      //                           sBottom = m.relative.dy / _pContrl.scale;
      //                           rRight = (((m.relative.dx / _pContrl.scale) / c.maxWidth -
      //                               context.read<Current>().getDrawing().originX) *
      //                               context.read<Current>().getcordiX())
      //                               .round();
      //                           rBottom =
      //                               (((m.relative.dy / _pContrl.scale) / (c.maxWidth / (420 / 297)) -
      //                                   context.read<Current>().getDrawing().originY) *
      //                                   context.read<Current>().getcordiY())
      //                                   .round();
      //                           s2 = Offset(
      //                               (((m.relative.dx / _pContrl.scale) / c.maxWidth -
      //                                   context.read<Current>().getDrawing().originX) *
      //                                   context.read<Current>().getcordiX()),
      //                               (((m.relative.dy / _pContrl.scale) / (c.maxWidth / (420 / 297)) -
      //                                   context.read<Current>().getDrawing().originY) *
      //                                   context.read<Current>().getcordiY()));
      //                           print(s2);
      //                           sCheck = false;
      //                         }
      //                       });
      //                     },
      //                     child: Listener(
      //                       onPointerHover: (h){
      //                         setState(() {
      //                           hover = h.localPosition;
      //                           print(hover);
      //                         });
      //                       },
      //                       child: Stack(
      //                         children: [
      //                           Image.asset(
      //                               'asset/photos/${context.watch<Current>().getDrawing().localPath}'),
      //                           CustomPaint(
      //                             painter: CrossHairPaint(hover),
      //                             // painter: CrossHairPaint(hover,width: context.size.width,height: context.size.height),
      //                           ),
      //                           CustomPaint(
      //                             painter: SetInfoDraw(
      //                               setPoint: _origin,
      //                               left: sLeft,
      //                               top: sTop,
      //                               right: sRight,
      //                               bottom: sBottom,
      //                               // tP: measurement,
      //                             ),
      //                           ),
      //                           // measurement != null && measurement.length > 1
      //                           //     ? Stack(
      //                           //         children: measurement
      //                           //             .sublist(1)
      //                           //             .map((e) => Positioned.fromRect(
      //                           //                 rect: Rect.fromCenter(
      //                           //                     center: (measurement[measurement.indexOf(e) - 1] +
      //                           //                             measurement[measurement.indexOf(e)]) /
      //                           //                         2,
      //                           //                     width: 100,
      //                           //                     height: 100),
      //                           //                 child: Center(
      //                           //                     child: Transform.rotate(
      //                           //                   angle: pi /
      //                           //                       (180 /
      //                           //                           Line(measurement[measurement.indexOf(e) - 1],
      //                           //                                   measurement[measurement.indexOf(e)])
      //                           //                               .degree()),
      //                           //                   child: Text(
      //                           //                       '${Line(rmeasurement[measurement.indexOf(e) - 1], rmeasurement[measurement.indexOf(e)]).length().round()}'
      //                           //                       // style: TextStyle(color: Colors.white),
      //                           //                       ),
      //                           //                 ))))
      //                           //             .toList(),
      //                           //       )
      //                           //     : Container(),
      //                           context.watch<Current>().getDrawing().roomMap == []
      //                               ? Container()
      //                               : Stack(
      //                             children: context
      //                                 .watch<Current>()
      //                                 .getDrawing()
      //                                 .roomMap
      //                                 .map((e) => Positioned.fromRect(
      //                                 rect: Rect.fromLTRB(
      //                                   e['left'].toDouble() / (5940 / c.maxWidth),
      //                                   e['top'].toDouble() / (5940 / c.maxWidth),
      //                                   e['right'].toDouble() / (5940 / c.maxWidth),
      //                                   e['bottom'].toDouble() / (5940 / c.maxWidth),
      //                                 ),
      //                                 child: Container(
      //                                   color: Color.fromRGBO(0, 0, 0, 0.6),
      //                                 )))
      //                                 .toList(),
      //                           ),
      //                           context.watch<Current>().getDrawing().callOutMap == []
      //                               ? Container()
      //                               : Stack(
      //                             children: context
      //                                 .watch<Current>()
      //                                 .getDrawing()
      //                                 .callOutMap
      //                                 .map((e) => Positioned.fromRect(
      //                                 rect: Rect.fromLTRB(
      //                                   e['left'].toDouble() / (5940 / c.maxWidth),
      //                                   e['top'].toDouble() / (5940 / c.maxWidth),
      //                                   e['right'].toDouble() / (5940 / c.maxWidth),
      //                                   e['bottom'].toDouble() / (5940 / c.maxWidth),
      //                                 ),
      //                                 child: GestureDetector(
      //                                   onLongPress: () {},
      //                                   child: Container(
      //                                     color: Color.fromRGBO(0, 0, 255, 0.6),
      //                                   ),
      //                                 )))
      //                                 .toList(),
      //                           ),
      //                           context.watch<Current>().getDrawing().detailInfoMap == []
      //                               ? Container()
      //                               : Stack(
      //                             children: context
      //                                 .watch<Current>()
      //                                 .getDrawing()
      //                                 .detailInfoMap
      //                                 .map((e) => Positioned.fromRect(
      //                                 rect: Rect.fromLTRB(
      //                                   e['left'].toDouble() / (5940 / c.maxWidth),
      //                                   e['top'].toDouble() / (5940 / c.maxWidth),
      //                                   e['right'].toDouble() / (5940 / c.maxWidth),
      //                                   e['bottom'].toDouble() / (5940 / c.maxWidth),
      //                                 ),
      //                                 child: Container(
      //                                   color: Color.fromRGBO(0, 255, 0, 0.6),
      //                                 )))
      //                                 .toList(),
      //                           ),
      //                           ocrGet == null && iS == null && ocrFinList != []
      //                               ? Container()
      //                               : Stack(
      //                             children: ocrGet.dataList
      //                                 .map((v) => Positioned.fromRect(
      //                               rect: Rect.fromPoints(
      //                                 Offset(v['rect']['left'], v['rect']['top']) /
      //                                     (5940 / c.maxWidth),
      //                                 Offset(v['rect']['right'], v['rect']['bottom']) /
      //                                     (5940 / c.maxWidth),
      //                               ),
      //                               child: InkWell(
      //                                 onTap: () {
      //                                   ocrFinList =
      //                                       List.filled(ocrGet.dataList.length, false);
      //                                   setState(() {
      //                                     ocrFinList[ocrGet.dataList
      //                                         .indexWhere((e) => e == v)] =
      //                                     !ocrFinList[ocrGet.dataList
      //                                         .indexWhere((e) => e == v)];
      //                                     field0.text = v['text'];
      //                                   });
      //                                 },
      //                                 child: Container(
      //                                   decoration: BoxDecoration(
      //                                     color: ocrFinList[ocrGet.dataList
      //                                         .indexWhere((e) => e == v)] ==
      //                                         false
      //                                         ? Color.fromRGBO(255, 0, 0, 0.3)
      //                                         : Color.fromRGBO(0, 255, 0, 0.3),
      //                                     //   border: ocrFinList[ocrGet.dataList
      //                                     //               .indexWhere((e) => e.toString() == v.toString())] ==
      //                                     //           false
      //                                     //       ? Border.all(color: Colors.red, width: 0.01,)
      //                                     //       : Border.all(color: Colors.green, width: 0.01,
      //                                     // ),
      //                                   ),
      //                                 ),
      //                               ),
      //                             ))
      //                                 .toList(),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           );
      //         }),
      //       ),
      //       Expanded(
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: Column(
      //                 children: [
      //                   buildOcrCategorySelect(),
      //                   Expanded(
      //                     child: Column(
      //                       children: [
      //                         Column(
      //                           mainAxisSize: MainAxisSize.min,
      //                           children: [
      //                             buildEnter(context),
      //                           ],
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Expanded(
      //               child: buildServerDataView(context),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   );
      // }),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _pContrl.dispose();
    field0.dispose();
    field1.dispose();
    field2.dispose();
    field3.dispose();
    field4.dispose();
    field5.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // FloatingActionButton(
          //   heroTag: null,
          //   child: Center(
          //       child: Text(
          //     '+',
          //     textScaleFactor: 2,
          //   )),
          //   onPressed: () {
          //     setState(() {
          //       _pContrl.scale = _pContrl.scale + 0.2;
          //     });
          //   },
          // ),
          // SizedBox(
          //   width: 20,
          // ),
          // FloatingActionButton(
          //   heroTag: null,
          //   child: Center(
          //       child: Text(
          //     '-',
          //     textScaleFactor: 2,
          //   )),
          //   onPressed: () {
          //     setState(() {
          //       _pContrl.scale = _pContrl.scale - 0.2;
          //     });
          //   },
          // ),
          // SizedBox(
          //   width: 20,
          // ),
          // FloatingActionButton(
          //     heroTag: null,
          //     onPressed: () {
          //       measurement = [];
          //       rmeasurement = [];
          //     }),
          // SizedBox(
          //   width: 10,
          // ),
          FloatingActionButton(
            heroTag: null,
            child: Text('On'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('ocrData')
                  .doc(context.read<CP>().getDrawing().drawingNum)
                  .get()
                  .then((e) {
                ocrGet = OcrData.fromSnapshot(e);
                ocrFinList = List.filled(ocrGet.dataList.length, false);
              });
              print(context.read<CP>().getDrawing().callOutMap.toString());
              print(ocrGet.dataList.length);
              print(iS);
              setState(() {});
            },
          ),
        ],
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event.character == '+' || event.character == '=') {
            setState(() {
              _pContrl.scale = _pContrl.scale + 0.2;
            });
          } else if (event.character == '-') {
            setState(() {
              _pContrl.scale = _pContrl.scale - 0.2;
            });
          }
        },
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: DropdownSearch<Drawing>(
                      items: drawings,
                      maxHeight: 600,
                      // onFind: (String filter) => getData(filter),
                      label: "도면을 선택해주세요",
                      onChanged: (e) {
                        setState(() async {
                          context.read<CP>().changePath(e);
                          String tempRoot = 'asset/photos/${context.read<CP>().getDrawing().localPath}';
                          ByteData bytes = await rootBundle.load(tempRoot);
                          String tempPath = (await getTemporaryDirectory()).path;
                          String tempName = '$tempPath/${context.read<CP>().getDrawing().drawingNum}.png';
                          File file = File(tempName);
                          await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                          decodeImage = await decodeImageFromList(file.readAsBytesSync());
                          iS = decodeImage.width / _keyA.currentContext.size.width;
                          ocrFinList = List.filled(visionText.blocks.length, false);
                          recaculate();
                          setState(() {});
                        });
                      },
                      showSearchBox: true,
                    ),
                  ),
                  Expanded(
                    child: InfoCategory(drawings: drawings),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Scaffold(
                  bottomNavigationBar: BottomNavigationBar(
                    onTap: (index) {
                      setState(() {
                        _bInt = index;
                      });
                    },
                    currentIndex: _bInt,
                    items: [
                      BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.grid), label: '그리드생성'),
                      BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.cursor_pointer), label: '원점설정'),
                      BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.information), label: '정보맵핑')
                    ],
                  ),
                  body: bnb[_bInt]
            ),),
          ],
        ),
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

  buildEnter(BuildContext context) {
    switch (selectCategory) {
      case OcrCategory.CallOut:
        return buildCallOutDataField(context);
      case OcrCategory.DetailInfo:
        return buildDetailInfoField(context);
      case OcrCategory.Room:
        return buildRoomDateField(context);
      case OcrCategory.Elevation:
        return buildRoomDateField(context);
      case OcrCategory.Section:
        return buildRoomDateField(context);
    }
  }

  buildServerDataView(BuildContext context) {
    switch (selectCategory) {
      case OcrCategory.CallOut:
        return ListView(
            children: context
                .watch<CP>()
                .getDrawing()
                .callOutMap
                .reversed
                .map((e) => Card(
                      child: ListTile(
                        title: Text('[${e['id']}]${e['name']}'),
                      ),
                    ))
                .toList());
      case OcrCategory.DetailInfo:
        return ListView(
            children: context
                .watch<CP>()
                .getDrawing()
                .detailInfoMap
                .reversed
                .map((e) => Card(
                      child: ListTile(
                        title: Text('[${e['id']}]${e['name']}'),
                      ),
                    ))
                .toList());
      case OcrCategory.Room:
        return ListView(
            children: context
                .watch<CP>()
                .getDrawing()
                .roomMap
                .reversed
                .map((e) => Card(
                      child: ListTile(
                        title: Text('[${e['id']}]${e['name']}'),
                      ),
                    ))
                .toList());
      case OcrCategory.Elevation:
        return ListView(
            children: context
                .watch<CP>()
                .getDrawing()
                .roomMap
                .reversed
                .map((e) => Card(
                      child: ListTile(
                        title: Text('[${e['id']}]${e['name']}'),
                      ),
                    ))
                .toList());
      case OcrCategory.Section:
        return ListView(
            children: context
                .watch<CP>()
                .getDrawing()
                .roomMap
                .reversed
                .map((e) => Card(
                      child: ListTile(
                        title: Text('[${e['id']}]${e['name']}'),
                      ),
                    ))
                .toList());
    }
  }

  Widget buildDetailInfoField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: field0,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name을 입력하세요',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: field1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '카테고리 를 입력하세요',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Map _selBox = ocrGet.dataList[ocrFinList.indexWhere((bool) => bool == true)]['rect'];
                  context.read<CP>().getDrawing().detailInfoMap.add(<String, dynamic>{
                    'name': field0.text,
                    'category': field1.text,
                    'left': _selBox['left'],
                    'top': _selBox['top'],
                    'right': _selBox['right'],
                    'bottom': _selBox['bottom'],
                    'x': debugX,
                    'y': debugY,
                    'z': context.read<CP>().getDrawing().floor,
                  });
                  context.read<CP>().getDrawing().detailInfoMap.toSet().toList();
                  FirebaseFirestore.instance
                      .collection('drawing')
                      .doc(context.read<CP>().getDrawing().drawingNum)
                      .update(context.read<CP>().getDrawing().toJson());
                  ocrFinList = List.filled(ocrGet.dataList.length, false);
                });
              },
              child: Container(height: 116, child: Center(child: Text('DetailInfo 등록')))),
        )
      ],
    );
  }

  Widget buildCallOutDataField(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: field0,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name을 입력하세요',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: field1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID 를 입력하세요',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: field2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '카테고리 를 입력하세요',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Map _selBox = ocrGet.dataList[ocrFinList.indexWhere((bool) => bool == true)]['rect'];
                  Rect tempRect = Rect.fromPoints(s1, s2);
                  context.read<CP>().getDrawing().callOutMap.add(<String, dynamic>{
                    'name': field0.text,
                    'id': field1.text,
                    'category': field2.text,
                    'left': _selBox['left'],
                    'top': _selBox['top'],
                    'right': _selBox['right'],
                    'bottom': _selBox['bottom'],
                    'bLeft': tempRect.left,
                    'bTop': tempRect.top,
                    'bRight': tempRect.right,
                    'bBottom': tempRect.bottom,
                    'x': debugX,
                    'y': debugY,
                    'z': context.read<CP>().getDrawing().floor,
                  });
                  context.read<CP>().getDrawing().callOutMap.toSet().toList();
                  FirebaseFirestore.instance
                      .collection('drawing')
                      .doc(context.read<CP>().getDrawing().drawingNum)
                      .update(context.read<CP>().getDrawing().toJson());
                  ocrFinList = List.filled(ocrGet.dataList.length, false);
                });
              },
              child: Container(height: 182, child: Center(child: Text('CallOut 등록')))),
        ),
      ],
    );
  }

  Widget buildRoomDateField(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: field0,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name을 입력하세요',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: field1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID를 입력하세요',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: field2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '천정고 입력하세요',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Map _selBox = ocrGet.dataList[ocrFinList.indexWhere((bool) => bool == true)]['rect'];
                  Rect tempRect = Rect.fromPoints(s1, s2);
                  context.read<CP>().getDrawing().roomMap.add(<String, dynamic>{
                    'name': field0.text,
                    'id': field1.text,
                    'left': _selBox['left'],
                    'top': _selBox['top'],
                    'right': _selBox['right'],
                    'bottom': _selBox['bottom'],
                    'bLeft': tempRect.left,
                    'bTop': tempRect.top,
                    'bRight': tempRect.right,
                    'bBottom': tempRect.bottom,
                    'x': debugX,
                    'y': debugY,
                    'z': context.read<CP>().getDrawing().floor.toDouble(),
                    'sealL': int.parse(field2.text),
                  });
                  context.read<CP>().getDrawing().roomMap.toSet().toList();
                  FirebaseFirestore.instance
                      .collection('drawing')
                      .doc(context.read<CP>().getDrawing().drawingNum)
                      .update(context.read<CP>().getDrawing().toJson());
                  ocrFinList = List.filled(ocrGet.dataList.length, false);
                });
              },
              child: Container(height: 182, child: Center(child: Text('Room 등록')))),
        ),
      ],
    );
  }

  Widget buildOcrCategorySelect() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: RadioListTile(
            title: Text('Room'),
            value: OcrCategory.Room,
            groupValue: _ocrCategory,
            onChanged: (OcrCategory value) {
              setState(() {
                selectCategory = value;
                _ocrCategory = value;
              });
            },
          ),
        ),
        Card(
          child: RadioListTile(
            title: Text('CallOut'),
            value: OcrCategory.CallOut,
            groupValue: _ocrCategory,
            onChanged: (OcrCategory value) {
              setState(() {
                selectCategory = value;
                _ocrCategory = value;
              });
            },
          ),
        ),
        Card(
          child: RadioListTile(
            title: Text('DetailInfo'),
            value: OcrCategory.DetailInfo,
            groupValue: _ocrCategory,
            onChanged: (OcrCategory value) {
              setState(() {
                selectCategory = value;
                _ocrCategory = value;
              });
            },
          ),
        ),
        Card(
          child: RadioListTile(
            title: Text('Elevation'),
            value: OcrCategory.Elevation,
            groupValue: _ocrCategory,
            onChanged: (OcrCategory value) {
              setState(() {
                selectCategory = value;
                _ocrCategory = value;
              });
            },
          ),
        ),
        Card(
          child: RadioListTile(
            title: Text('Section'),
            value: OcrCategory.Section,
            groupValue: _ocrCategory,
            onChanged: (OcrCategory value) {
              setState(() {
                selectCategory = value;
                _ocrCategory = value;
              });
            },
          ),
        ),
      ],
    );
  }

  double computeArea(List<Offset> a) {
    double area = 0;
    a.sublist(1).forEach((e) {
      var x1 = a[a.indexOf(e) - 1].dx;
      var x2 = a[a.indexOf(e)].dx;
      var y1 = a[a.indexOf(e) - 1].dy;
      var y2 = a[a.indexOf(e)].dy;

      area += x1 * y2;
      area -= y1 * x2;
    });
    area += a.last.dx * a.first.dy;
    area -= a.last.dy * a.first.dx;
    area /= 2.0;
    area = area.abs();
    return area;
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

class SetInfoDraw extends CustomPainter {
  Offset setPoint;
  double top;
  double bottom;
  double left;
  double right;
  List<Offset> tP;

  SetInfoDraw({this.left, this.top, this.right, this.bottom, this.setPoint, this.tP});

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
    Paint crossHair = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0
      ..color = Color.fromRGBO(255, 0, 0, 0.6);
    Paint paint4 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25.0
      ..color = Color.fromRGBO(255, 0, 0, 1);
    Paint paint5 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill
      ..color = Color.fromRGBO(0, 255, 0, 0.5);

    left == null && top == null && right == null && bottom == null
        ? null
        : canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    left == null && top == null && right == null && bottom == null
        ? null
        : canvas.drawPoints(PointMode.points, [Offset(left, top)], paint5);
    left == null && top == null && right == null && bottom == null
        ? null
        : canvas.drawPoints(PointMode.points, [Offset(right, bottom)], paint2);

    // Path p = Path();
    // p.moveTo(tP[0].dx, tP[0].dy);
    // tP.forEach((e) {
    //   p.lineTo(e.dx, e.dy);
    // });
    // p.close();
    setPoint == null ? null : canvas.drawPoints(PointMode.points, [setPoint], paint2);
    // setPoint == null ? null : canvas.drawPath(p, paint5);
    // setPoint == null ? null : canvas.drawPoints(PointMode.points, tP, paint4);
    // setPoint == null ? null : canvas.drawPoints(PointMode.polygon, tP, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Info {
  List<String> con = [
    '건축',
    '구조',
    '토목',
    '조경',
    '설비',
    '전기',
    '통신',
    '기계소방',
    '전기소방',
    '미분류',
  ];
  List<String> doc = [
    '평면도',
    '확대평면도',
    '입면도',
    '확대입면도',
    '단면도',
    '확대단면도',
    '일람표',
    '안내도',
    '계획도',
    '실내재료마감상세도',
    '기타',
    '미분류',
  ];
  List<String> axis = ['horizontal', 'vertical'];
  List<String> level = [
    '-2',
    '-1',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];
}

class InfoCategory extends StatefulWidget {
  List<Drawing> drawings;

  InfoCategory({Key key, this.drawings}) : super(key: key);

  @override
  _InfoCategoryState createState() => _InfoCategoryState();
}

class _InfoCategoryState extends State<InfoCategory> {
  TextEditingController field5 = TextEditingController();
  Map infoCategory = {
    'con': [
      '건축',
      '구조',
      '토목',
      '조경',
      '설비',
      '전기',
      '통신',
      '기계소방',
      '전기소방',
    ],
    'doc': [
      '평면도',
      '확대평면도',
      '입면도',
      '확대입면도',
      '단면도',
      '확대단면도',
      '일람표',
      '안내도',
      '계획도',
      '실내재료마감상세도',
      '기타',
      '미분류',
    ],
    'axis': ['horizontal', 'vertical']
  };
  String _selected = 'doc';
  Info info = Info();
  double tempX;
  double tempY;
  ScrollController scrollController ;


  @override
  void initState() {
    super.initState();
    scrollController =ScrollController();
    field5.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    field5.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, c) {
      return Container(
        width: c.maxWidth,
        height: c.maxHeight,
        child: Column(
          children: [
            buildDrawingFinder(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      controller: null,
                        children: [
                      ExpansionTile(
                        title: Text('공정'),
                        children: info.con.map((e) => buildInfoConTile(e)).toList(),
                      ),
                      Divider(),
                      ExpansionTile(
                        title: Text('Level'),
                        children: info.level.map((e) => buildInfoLevelTile(e)).toList(),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: ListView(
                      controller: null,
                      children: [
                        ExpansionTile(
                          title: Text('문서분류'),
                          children: info.doc.map((e) => buildInfoDocTile(e)).toList(),
                        ),
                        Divider(),
                        ExpansionTile(
                          title: Text('축'),
                          children: info.axis.map((e) => buildInfoAxisTile(e)).toList(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Scrollbar(
                      controller: scrollController,
                      isAlwaysShown: true,
                      thickness: 20,
                      hoverThickness: 30,
                      child: ListView(
                        controller: scrollController,
                        children: widget.drawings
                            .where((f) => f
                            .toString()
                            .replaceAll(' ', '')
                            .toLowerCase()
                            .contains(field5.text.replaceAll(' ', '').toLowerCase()))
                            .map(
                              (e) => Card(
                                child: ListTile(
                                  selected: e.checked,
                                  selectedTileColor: Colors.orange[50],
                                  onTap: () {
                                    setState(() {
                                      e.checked = !e.checked;
                                    });
                                  },
                                  leading: InkWell(
                                    onTap: ()=>context.read<CP>().changePath(e),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(e.listCategory),
                                        Text(e.listSubNum),
                                      ],
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check),
                                      Icon(Icons.check),
                                      Icon(Icons.check),
                                    ],
                                  ),
                                  title: e.originX == 0
                                      ? AutoSizeText(
                                          e.title,
                                          maxLines: 2,
                                        )
                                      : AutoSizeText(
                                          e.title,
                                          maxLines: 2,
                                          style: TextStyle(color: Colors.redAccent),
                                        ),
                                  subtitle: Row(
                                    children: [
                                      AutoSizeText('[${e.originX.toStringAsFixed(2)}] [${e.originY.toStringAsFixed(2)}]'),
                                      TextButton(onPressed: (){
                                        tempX = e.originX;
                                        tempY = e.originY;
                                      }, child: Text('복사')),
                                      TextButton(onPressed: (){
                                       setState(() {
                                         e.originX = tempX;
                                         e.originY = tempY;
                                         FirebaseFirestore.instance.collection('drawing').doc(e.drawingNum).update(e.toJson());
                                       });
                                      }, child: Text('붙여넣기')),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }));
  }

  ListTile buildInfoTile(List<Drawing> filter, String e) {
    return ListTile(
      onTap: () {
        setState(() {
          filter.forEach((d) {
            d.doc = e;
            FirebaseFirestore.instance.collection('drawing').doc(d.drawingNum).update(d.toJson());
          });
        });
      },
      selected: filter.length == filter.where((a) => a.doc == e).toList().length,
      title: AutoSizeText(
        e,
        maxLines: 1,
      ),
      trailing: TextButton(
        child: Text('${widget.drawings.where((d) => d.doc == e).length}'),
        onPressed: () {
          Get.defaultDialog(title: e);
        },
      ),
    );
  }

  ListTile buildInfoLevelTile(String e) {
    List<Drawing> filter = widget.drawings.where((d) => d.checked == true).toList();
    return ListTile(
      onTap: () {
        setState(() {
          filter.forEach((d) {
            d.floor = num.parse(e);
            FirebaseFirestore.instance.collection('drawing').doc(d.drawingNum).update(d.toJson());
          });
        });
      },
      selected: filter.length == filter.where((a) => a.floor == num.parse(e)).toList().length,
      title: AutoSizeText(
        e,
        maxLines: 1,
      ),
      trailing: TextButton(
        child: Text('${widget.drawings.where((d) => d.floor == num.parse(e)).length}'),
        onPressed: () {
          Get.defaultDialog(title: e);
        },
      ),
    );
  }

  ListTile buildInfoConTile(String e) {
    List<Drawing> filter = widget.drawings.where((d) => d.checked == true).toList();
    return ListTile(
      onTap: () {
        setState(() {
          filter.forEach((d) {
            d.con = e;
            FirebaseFirestore.instance.collection('drawing').doc(d.drawingNum).update(d.toJson());
          });
        });
      },
      selected: filter.length == filter.where((a) => a.con == e).toList().length,
      title: AutoSizeText(
        e,
        maxLines: 1,
      ),
      trailing: TextButton(
        child: Text('${widget.drawings.where((d) => d.con == e).length}'),
        onPressed: () {
          Get.defaultDialog(title: e);
        },
      ),
    );
  }

  ListTile buildInfoDocTile(String e) {
    List<Drawing> filter = widget.drawings.where((d) => d.checked == true).toList();
    return ListTile(
      onLongPress: () {
        setState(() {
          filter.forEach((d) {
            d.doc = e;
            FirebaseFirestore.instance.collection('drawing').doc(d.drawingNum).update(d.toJson());
          });
        });
      },
      selected: filter.length == filter.where((a) => a.doc == e).toList().length,
      title: AutoSizeText(
        e,
        maxLines: 1,
      ),
      trailing: TextButton(
        child: Text('${widget.drawings.where((d) => d.doc == e).length}'),
        onPressed: () {
          Get.defaultDialog(
              title: e,
              content: Container(
                height: 800,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: widget.drawings.where((d) => d.doc == e).map((a) => Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Chip(label: Text(a.toString())),
                    )).toList(),
                  ),
                ),
              ));
        },
      ),
    );
  }

  ListTile buildInfoAxisTile(String e) {
    List<Drawing> filter = widget.drawings.where((d) => d.checked == true).toList();
    bool check = e != 'horizontal';
    return ListTile(
      onTap: () {
        setState(() {
          filter.forEach((d) {
            d.axis = check;
            FirebaseFirestore.instance.collection('drawing').doc(d.drawingNum).update(d.toJson());
          });
        });
      },
      selected: filter.length == filter.where((a) => a.axis == check).toList().length,
      title: AutoSizeText(
        e,
        maxLines: 1,
      ),
      trailing: TextButton(
        child: Text('${widget.drawings.where((d) => d.axis == check).length}'),
        onPressed: () {
          Get.defaultDialog(title: e);
        },
      ),
    );
  }

  Row buildDrawingFinder() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              child: TextField(
                controller: field5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Filter',
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ElevatedButton(
            onPressed: () {},
            child: Text('${widget.drawings.where((e) => e.checked == true).length}개 등록'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                widget.drawings
                    .where((f) => f
                        .toString()
                        .replaceAll(' ', '')
                        .toLowerCase()
                        .contains(field5.text.replaceAll(' ', '').toLowerCase()))
                    .forEach((d) {
                  d.checked = true;
                });
              });
            },
            child: Text('전체선택'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                widget.drawings
                    .where((f) => f
                        .toString()
                        .replaceAll(' ', '')
                        .toLowerCase()
                        .contains(field5.text.replaceAll(' ', '').toLowerCase()))
                    .forEach((d) {
                  d.checked = false;
                });
              });
            },
            child: Text('선택해제'),
          ),
        ),
      ],
    );
  }
}
