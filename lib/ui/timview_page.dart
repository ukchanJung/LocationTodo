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
import 'package:flutter_app_location_todo/data/standard_detail_list.dart';
import 'package:flutter_app_location_todo/data/structureJson.dart';
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

class TimView extends StatefulWidget {
  @override
  _TimViewState createState() => _TimViewState();
}

class _TimViewState extends State<TimView> {
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

  @override
  void initState() {
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
              : Expanded(
                  child: ListView(
                    children: drawings
                        .map((e) => ListTile(
                              title: Text(e.title),
                              onTap: () {
                                setState(() async {
                                  context.read<Current>().changePath(e);
                                  String tempRoot = 'asset/photos/${context.read<Current>().getDrawing().localPath}';
                                  ByteData bytes = await rootBundle.load(tempRoot);
                                  String tempPath = (await getTemporaryDirectory()).path;
                                  String tempName = '$tempPath/${context.read<Current>().getDrawing().drawingNum}.png';
                                  File file = File(tempName);
                                  await file
                                      .writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                                  FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);
                                  final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
                                  print(textRecognizer);
                                  visionText = await textRecognizer.processImage(vIa);
                                  print(visionText);
                                  decodeImage = await decodeImageFromList(file.readAsBytesSync());
                                  iS = decodeImage.width / _keyA.currentContext.size.width;
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: FloatingActionButton(
          //     heroTag: null,
          //     onPressed: () async {
          //       drawings.forEach((e) async {
          //         String tempRoot = 'asset/photos/${e.localPath}';
          //         ByteData bytes = await rootBundle.load(tempRoot);
          //         String tempPath = (await getTemporaryDirectory()).path;
          //         String tempName = '$tempPath/${e.drawingNum}.png';
          //         File file = File(tempName);
          //         await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
          //         FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);
          //         final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
          //         visionText = await textRecognizer.processImage(vIa);
          //         List<Map> tempList = visionText.blocks
          //             .map((v) => {
          //                   'text': v.text,
          //                   'rect': {
          //                     'left': v.boundingBox.left,
          //                     'top': v.boundingBox.top,
          //                     'right': v.boundingBox.right,
          //                     'bottom': v.boundingBox.bottom,
          //                   }
          //                 })
          //             .toList();
          //         FirebaseFirestore.instance
          //             .collection('ocrData')
          //             .doc(e.drawingNum)
          //             .set({'drawingNum': e.drawingNum, 'dataList': tempList});
          //         print('등록성공');
          //         print(tempList);
          //       });
          //     },
          //     child: Text('전체등록'),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                standarddetail.forEach((e) async {
                  String tempRoot = 'asset/standarddetail/${e['path']}';
                  ByteData bytes = await rootBundle.load(tempRoot);
                  String tempPath = (await getTemporaryDirectory()).path;
                  String tempName = '$tempPath/${e['path']}';
                  File file = File(tempName);
                  await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                  FirebaseVisionImage vIa = FirebaseVisionImage.fromFilePath(tempName);
                  // FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);
                  final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
                  visionText = await textRecognizer.processImage(vIa);
                  List<Map> tempList = visionText.blocks
                      .map((v) => {
                            'text': v.text,
                            'rect': {
                              'left': v.boundingBox.left,
                              'top': v.boundingBox.top,
                              'right': v.boundingBox.right,
                              'bottom': v.boundingBox.bottom,
                            }
                          })
                      .toList();
                  FirebaseFirestore.instance
                      .collection('standarddetail')
                      .doc(e['path'])
                      .set({'path': e['path'], 'dataList': tempList,'fulltext':visionText.text});
                  print('등록성공');
                  print(tempList);
                }
                );
                print('전체등록성공');
              },
              child: Text('상세도등록'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                structureJson.forEach((e) async {
                  String tempRoot = 'asset/structure/${e['path']}';
                  ByteData bytes = await rootBundle.load(tempRoot);
                  String tempPath = (await getTemporaryDirectory()).path;
                  String tempName = '$tempPath/${e['path']}';
                  File file = File(tempName);
                  await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                  FirebaseVisionImage vIa = FirebaseVisionImage.fromFilePath(tempName);
                  // FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);
                  final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
                  visionText = await textRecognizer.processImage(vIa);
                  List<Map> tempList = visionText.blocks
                      .map((v) => {
                            'text': v.text,
                            'rect': {
                              'left': v.boundingBox.left,
                              'top': v.boundingBox.top,
                              'right': v.boundingBox.right,
                              'bottom': v.boundingBox.bottom,
                            }
                          })
                      .toList();
                  FirebaseFirestore.instance
                      .collection('generalInfo')
                      .doc(e['path'])
                      .set({'path': e['path'], 'dataList': tempList,'fulltext':visionText.text});
                  print('등록성공');
                  print(tempList);
                }
                );
                print('전체등록성공');
              },
              child: Text('시방서등록'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                context
                    .read<Current>()
                    .changePath(drawings.elementAt(drawings.indexOf(context.read<Current>().getDrawing()) - 1));
              },
              child: Text('이전'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                context
                    .read<Current>()
                    .changePath(drawings.elementAt(drawings.indexOf(context.read<Current>().getDrawing()) + 1));
              },
              child: Text('다음'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                setState(() async {
                  await currentOcr(context);
                  print('ocr성공');
                });
              },
              child: Text('OCR'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                setState(() {
                  List<Map> tempList = visionText.blocks
                      .map((e) => {
                            'text': e.text,
                            'rect': {
                              'left': e.boundingBox.left,
                              'top': e.boundingBox.top,
                              'right': e.boundingBox.right,
                              'bottom': e.boundingBox.bottom,
                            }
                          })
                      .toList();
                  FirebaseFirestore.instance
                      .collection('ocrData')
                      .doc(context.read<Current>().getDrawing().drawingNum)
                      .set({'dataList': tempList});
                  print('등록성공');
                });
              },
              child: Text('서버등록'),
            ),
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () async {
              // print(visionText.blocks.length);
              // FirebaseFirestore.instance.collection('drawing').doc(context
              //     .read<Current>()
              //     .getDrawing()
              //     .drawingNum).update({
              //   "ocrData": visionText.blocks.map((e) =>
              //   {
              //     "text": e.text,
              //     "Rect": {
              //       "L": e.boundingBox.left,
              //       "T": e.boundingBox.top,
              //       "R": e.boundingBox.right,
              //       "B": e.boundingBox.bottom
              //     }
              //   }).toList()
              // });
              // String tempRoot
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownSearch<Drawing>(
              items: drawings,
              maxHeight: 600,
              // onFind: (String filter) => getData(filter),
              label: "도면을 선택해주세요",
              onChanged: (e) {
                setState(() async {
                  context.read<Current>().changePath(e);
                  await currentOcr(context);
                });
              },
              showSearchBox: true,
            ),
          ),
          Listener(
            onPointerSignal: (m) {
              if (m is PointerScrollEvent) {
                if (m.scrollDelta.dy > 1) {
                  _pContrl.scale = _pContrl.scale + 0.2;
                } else {
                  _pContrl.scale = _pContrl.scale - 0.2;
                }
                print(m.scrollDelta);
              }
              ;
            },
            child: AspectRatio(
              aspectRatio: 421 / 297,
              child: ClipRect(
                child: Container(
                  child: PhotoView.customChild(
                    key: _keyA,
                    controller: _pContrl,
                    scaleStateController: PhotoViewScaleStateController(),
                    minScale: 1.0,
                    maxScale: 10.0,
                    backgroundDecoration: BoxDecoration(color: Colors.transparent),
                    child: PositionedTapDetector(
                      onTap: (m) {
                        setState(
                          () {
                            _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
                            debugX = (((m.relative.dx / _pContrl.scale) / width -
                                        context.read<Current>().getDrawing().originX) *
                                    context.read<Current>().getcordiX())
                                .round();
                            debugY = (((m.relative.dy / _pContrl.scale) / heigh -
                                        context.read<Current>().getDrawing().originY) *
                                    context.read<Current>().getcordiY())
                                .round();
                            print(' 선택한점은 절대좌표 X: $debugX, Y: $debugY');
                            print(' 선택한점은 절대좌표 X: $sLeft,  Y: $sTop');
                            print(' 선택한점은 절대좌표 X: $sRight, Y: $sBottom');
                          },
                        );
                      },
                      onLongPress: (m) {
                        setState(() {
                          // _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
                          if (sCheck == false) {
                            sLeft = m.relative.dx / _pContrl.scale;
                            sTop = m.relative.dy / _pContrl.scale;
                            rLeft = (((m.relative.dx / _pContrl.scale) / width -
                                        context.read<Current>().getDrawing().originX) *
                                    context.read<Current>().getcordiX())
                                .round();
                            rTop = (((m.relative.dy / _pContrl.scale) / heigh -
                                        context.read<Current>().getDrawing().originY) *
                                    context.read<Current>().getcordiY())
                                .round();
                            sCheck = true;
                          } else {
                            sRight = m.relative.dx / _pContrl.scale;
                            sBottom = m.relative.dy / _pContrl.scale;
                            rRight = (((m.relative.dx / _pContrl.scale) / width -
                                        context.read<Current>().getDrawing().originX) *
                                    context.read<Current>().getcordiX())
                                .round();
                            rBottom = (((m.relative.dy / _pContrl.scale) / heigh -
                                        context.read<Current>().getDrawing().originY) *
                                    context.read<Current>().getcordiY())
                                .round();
                            sCheck = false;
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                          CustomPaint(
                            painter: CallOutBoundary(
                              setPoint: _origin,
                              left: sLeft,
                              top: sTop,
                              right: sRight,
                              bottom: sBottom,
                            ),
                          ),
                          context.watch<Current>().getDrawing().roomMap == [] || visionText == null
                              ? Container()
                              : Stack(
                                  children: context
                                      .watch<Current>()
                                      .getDrawing()
                                      .roomMap
                                      .map((e) => Positioned.fromRect(
                                          rect: Rect.fromLTRB(
                                            e['left'].toDouble() / iS,
                                            e['top'].toDouble() / iS,
                                            e['right'].toDouble() / iS,
                                            e['bottom'].toDouble() / iS,
                                          ),
                                          child: Container(
                                            color: Color.fromRGBO(0, 0, 0, 0.6),
                                          )))
                                      .toList(),
                                ),
                          context.watch<Current>().getDrawing().callOutMap == [] || visionText == null
                              ? Container()
                              : Stack(
                                  children: context
                                      .watch<Current>()
                                      .getDrawing()
                                      .callOutMap
                                      .map((e) => Positioned.fromRect(
                                          rect: Rect.fromLTRB(
                                            e['left'].toDouble() / iS,
                                            e['top'].toDouble() / iS,
                                            e['right'].toDouble() / iS,
                                            e['bottom'].toDouble() / iS,
                                          ),
                                          child: GestureDetector(
                                            onLongPress: () {},
                                            child: Container(
                                              color: Color.fromRGBO(0, 0, 255, 0.6),
                                            ),
                                          )))
                                      .toList(),
                                ),
                          context.watch<Current>().getDrawing().detailInfoMap == [] || visionText == null
                              ? Container()
                              : Stack(
                                  children: context
                                      .watch<Current>()
                                      .getDrawing()
                                      .detailInfoMap
                                      .map((e) => Positioned.fromRect(
                                          rect: Rect.fromLTRB(
                                            e['left'].toDouble() / iS,
                                            e['top'].toDouble() / iS,
                                            e['right'].toDouble() / iS,
                                            e['bottom'].toDouble() / iS,
                                          ),
                                          child: Container(
                                            color: Color.fromRGBO(0, 255, 0, 0.6),
                                          )))
                                      .toList(),
                                ),
                          visionText != null && ocrLayer == true
                              ? Stack(
                                  children: visionText.blocks
                                      .map(
                                        (e) => Positioned.fromRect(
                                          rect: Rect.fromPoints(
                                              e.boundingBox.topLeft / iS, e.boundingBox.bottomRight / iS),
                                          child: InkWell(
                                            onLongPress: () {
                                              setState(() {
                                                ocrFinList[visionText.blocks.indexWhere((element) => element == e)] =
                                                    !ocrFinList[
                                                        visionText.blocks.indexWhere((element) => element == e)];
                                                field0.text = e.text;
                                              });
                                            },
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(e.text),
                                                    content: Column(
                                                      children: drawings
                                                          .where((v) => v.drawingNum == e.text)
                                                          .map(
                                                            (e) => ListTile(
                                                              subtitle: Text(e.drawingNum),
                                                              title: Text(e.title),
                                                              onTap: () {
                                                                setState(() async {
                                                                  context.read<Current>().changePath(e);
                                                                  String tempRoot =
                                                                      'asset/photos/${context.read<Current>().getDrawing().localPath}';
                                                                  ByteData bytes = await rootBundle.load(tempRoot);
                                                                  String tempPath =
                                                                      (await getTemporaryDirectory()).path;
                                                                  String tempName =
                                                                      '$tempPath/${context.read<Current>().getDrawing().drawingNum}.png';
                                                                  File file = File(tempName);
                                                                  await file.writeAsBytes(bytes.buffer.asUint8List(
                                                                      bytes.offsetInBytes, bytes.lengthInBytes));

                                                                  FirebaseVisionImage vIa =
                                                                      FirebaseVisionImage.fromFile(file);
                                                                  final TextRecognizer textRecognizer =
                                                                      FirebaseVision.instance.cloudTextRecognizer();
                                                                  visionText = await textRecognizer.processImage(vIa);
                                                                  print(visionText);
                                                                  await decodeImageFromList(file.readAsBytesSync());

                                                                  iS = decodeImage.width /
                                                                      _keyA.currentContext.size.width;
                                                                  ocrFinList =
                                                                      List.filled(visionText.blocks.length, false);
                                                                  setState(() {});
                                                                });
                                                              },
                                                            ),
                                                          )
                                                          .toList(),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: ocrFinList[visionText.blocks
                                                              .indexWhere((element) => element == e)] ==
                                                          false
                                                      ? Color.fromRGBO(255, 0, 0, 0.3)
                                                      : Color.fromRGBO(200, 200, 200, 0.3),
                                                  border: ocrFinList[visionText.blocks
                                                              .indexWhere((element) => element == e)] ==
                                                          false
                                                      ? Border.all(color: Colors.red, width: 0.2)
                                                      : Border.all(color: Colors.green, width: 0.5)),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList())
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          buildOcrCategorySelect(),
          buildRoomDateField(context),
          buildCallOutDataField(context),
          buildDetailInfoField(context),
          Text(
            ' 선택한점은 절대좌표 X: $debugX, Y: $debugY',
            textScaleFactor: 2,
          ),
          Text(
            ' 선택한점은 절대좌표 X: $rLeft, Y: $rTop',
            textScaleFactor: 2,
          ),
          Text(
            ' 선택한점은 절대좌표 X: $rRight, Y: $rBottom',
            textScaleFactor: 2,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  ocrLayer = !ocrLayer;
                });
              },
              child: ocrLayer == true ? Text('OCR레이어 끄기') : Text('OCR레이어 켜기'))
        ],
      ),
    );
  }

  Future currentOcr(BuildContext context) async {
    String tempRoot = 'asset/photos/${context.read<Current>().getDrawing().localPath}';
    ByteData bytes = await rootBundle.load(tempRoot);
    String tempPath = (await getTemporaryDirectory()).path;
    String tempName = '$tempPath/${context.read<Current>().getDrawing().drawingNum}.png';
    File file = File(tempName);
    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);
    final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
    visionText = await textRecognizer.processImage(vIa);
    decodeImage = await decodeImageFromList(file.readAsBytesSync());
    iS = decodeImage.width / _keyA.currentContext.size.width;
    ocrFinList = List.filled(visionText.blocks.length, false);
    print(decodeImage.width);
    print(_keyA.currentContext.size.width);
    recaculate();
    setState(() {});
  }

  Row buildDetailInfoField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: field0,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name을 입력하세요',
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: field1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '카테고리 를 입력하세요',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Rect _selBox = visionText.blocks[ocrFinList.indexWhere((bool) => bool == true)].boundingBox;
                  context.read<Current>().getDrawing().detailInfoMap.add(<String, dynamic>{
                    'name': field0.text,
                    'category': field1.text,
                    'left': _selBox.left,
                    'top': _selBox.top,
                    'right': _selBox.right,
                    'bottom': _selBox.bottom,
                    'x': debugX,
                    'y': debugY,
                    'z': context.read<Current>().getDrawing().floor,
                  });
                  context.read<Current>().getDrawing().detailInfoMap.toSet().toList();
                  FirebaseFirestore.instance
                      .collection('drawing')
                      .doc(context.read<Current>().getDrawing().drawingNum)
                      .update(context.read<Current>().getDrawing().toJson());
                  ocrFinList = List.filled(visionText.blocks.length, false);
                });
              },
              child: Text('DetailInfo 등록')),
        )
      ],
    );
  }

  Row buildCallOutDataField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: field0,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name을 입력하세요',
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: field1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ID 를 입력하세요',
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: field2,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '카테고리 를 입력하세요',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Rect _selBox = visionText.blocks[ocrFinList.indexWhere((bool) => bool == true)].boundingBox;
                  context.read<Current>().getDrawing().callOutMap.add(<String, dynamic>{
                    'name': field0.text,
                    'id': field1.text,
                    'category': field2.text,
                    'left': _selBox.left,
                    'top': _selBox.top,
                    'right': _selBox.right,
                    'bottom': _selBox.bottom,
                    'bLeft': rLeft,
                    'bTop': rTop,
                    'bRight': rRight,
                    'bBottom': rBottom,
                    'x': debugX,
                    'y': debugY,
                    'z': context.read<Current>().getDrawing().floor,
                  });
                  context.read<Current>().getDrawing().callOutMap.toSet().toList();
                  FirebaseFirestore.instance
                      .collection('drawing')
                      .doc(context.read<Current>().getDrawing().drawingNum)
                      .update(context.read<Current>().getDrawing().toJson());
                  ocrFinList = List.filled(visionText.blocks.length, false);
                });
              },
              child: Text('CallOut 등록')),
        )
      ],
    );
  }

  Row buildRoomDateField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: field0,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name을 입력하세요',
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: field1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ID를 입력하세요',
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: field2,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '천정고 입력하세요',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Rect _selBox = visionText.blocks[ocrFinList.indexWhere((bool) => bool == true)].boundingBox;
                  context.read<Current>().getDrawing().roomMap.add(<String, dynamic>{
                    'name': field0.text,
                    'id': field1.text,
                    'left': _selBox.left,
                    'top': _selBox.top,
                    'right': _selBox.right,
                    'bottom': _selBox.bottom,
                    'bLeft': rLeft,
                    'bTop': rTop,
                    'bRight': rRight,
                    'bBottom': rBottom,
                    'x': debugX,
                    'y': debugY,
                    'z': context.read<Current>().getDrawing().floor.toDouble(),
                    'sealL': int.parse(field2.text),
                  });
                  context.read<Current>().getDrawing().roomMap.toSet().toList();
                  FirebaseFirestore.instance
                      .collection('drawing')
                      .doc(context.read<Current>().getDrawing().drawingNum)
                      .update(context.read<Current>().getDrawing().toJson());
                  ocrFinList = List.filled(visionText.blocks.length, false);
                });
              },
              child: Text('Room 등록')),
        )
      ],
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

  Row buildOcrCategorySelect() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: RadioListTile(
              title: Text('Room'),
              value: OcrCategory.Room,
              groupValue: _ocrCategory,
              onChanged: (OcrCategory value) {
                setState(() {
                  _ocrCategory = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: RadioListTile(
              title: Text('CallOut'),
              value: OcrCategory.CallOut,
              groupValue: _ocrCategory,
              onChanged: (OcrCategory value) {
                setState(() {
                  _ocrCategory = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: RadioListTile(
              title: Text('DetailInfo'),
              value: OcrCategory.DetailInfo,
              groupValue: _ocrCategory,
              onChanged: (OcrCategory value) {
                setState(() {
                  _ocrCategory = value;
                });
              },
            ),
          ),
        ),
      ],
    );
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

  CallOutBoundary({this.left, this.top, this.right, this.bottom, this.setPoint});

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
      ..strokeWidth = 25.0
      ..color = Color.fromRGBO(255, 0, 0, 1);
    Paint paint5 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..color = Color.fromRGBO(0, 255, 0, 1);

    left == null && top == null && right == null && bottom == null
        ? null
        : canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    left == null && top == null && right == null && bottom == null
        ? null
        : canvas.drawPoints(PointMode.points, [Offset(left, top)], paint5);
    left == null && top == null && right == null && bottom == null
        ? null
        : canvas.drawPoints(PointMode.points, [Offset(right, bottom)], paint2);
    setPoint == null ? null : canvas.drawPoints(PointMode.points, [setPoint], paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
