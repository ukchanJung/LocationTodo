import 'dart:io';
import 'dart:ui' as ui show Codec, FrameInfo, Image;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
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
  List<Drawing> favoriteds= [];
  OcrCategory _ocrCategory = OcrCategory.Room;
  TextEditingController field0 =TextEditingController();
  TextEditingController field1 =TextEditingController();
  TextEditingController field2 =TextEditingController();
  TextEditingController field3 =TextEditingController();
  TextEditingController field4 =TextEditingController();

  List<Gridtestmodel> testgrids = [];
  double deviceWidth;
  num width;
  num heigh;
  List<Offset> _realIPs;
  Offset _origin = Offset(0, 0);
  int debugX;
  int debugY;
  List<Point> relativeRectPoint ;
  Rect selectRect;
  List<bool> ocrFinList=[];




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
                    // ByteData bytes = await rootBundle.load(context.watch<Current>().getPath());
                    String tempPath = (await getTemporaryDirectory()).path;
                    String tempName = '$tempPath/${context.read<Current>().getDrawing().drawingNum}.png';
                    File file = File(tempName);
                    // File file = File('$tempPath/${context.watch<Current>().getName()}.png');
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(visionText.blocks.length);
          FirebaseFirestore.instance.collection('drawing').doc(context.read<Current>().getDrawing().drawingNum).update({
            "ocrData" : visionText.blocks.map((e) =>{
              "text": e.text,
              "Rect": {"L":e.boundingBox.left, "T":e.boundingBox.top, "R":e.boundingBox.right, "B":e.boundingBox.bottom}
            } ).toList()
          });
          // String tempRoot = 'asset/photos/${context.read<Current>().getDrawing().localPath}';
          // ByteData bytes = await rootBundle.load(tempRoot);
          // // ByteData bytes = await rootBundle.load(context.watch<Current>().getPath());
          // String tempPath = (await getTemporaryDirectory()).path;
          // String tempName = '$tempPath/${context.read<Current>().getDrawing().drawingNum}.png';
          // File file = File(tempName);
          // // File file = File('$tempPath/${context.watch<Current>().getName()}.png');
          // await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
          //
          // FirebaseVisionImage vIa = FirebaseVisionImage.fromFile(file);
          // final TextRecognizer textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
          // print(textRecognizer);
          //
          // visionText = await textRecognizer.processImage(vIa);
          // print(visionText);
          // decodeImage = await decodeImageFromList(file.readAsBytesSync());
          //
          // iS = decodeImage.width / _keyA.currentContext.size.width;
          // print(_photoViewController.scale);
          // setState(() {});
        },
      ),
      body: Column(
        children: [
          Container(height: 50,),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownSearch<Drawing>(
              items: drawings,
              maxHeight: 600,
              onFind: (String filter) => getData(filter),
              label: "도면을 선택해주세요",
              onChanged: (e){
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
                  visionText = await textRecognizer.processImage(vIa);
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
          // Row(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           setState(() {
          //             favoriteds.add(context.read<Current>().getDrawing());
          //             },
          //           );
          //         },
          //         child: Text('추가'),
          //       ),
          //     ),
          //
          //   ],
          // ),
          AspectRatio(
            aspectRatio: 421/297,
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
                      List<Point<double>> realParseList =
                      _realIPs.map((e) => Point(e.dx, e.dy)).toList();

                      setState(() {
                        _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
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
                         debugX = (((m.relative.dx / _pContrl.scale) / width -
                            context.read<Current>().getDrawing().originX) *
                            context.read<Current>().getcordiX())
                            .round();
                         debugY = (((m.relative.dy / _pContrl.scale) / heigh -
                            context.read<Current>().getDrawing().originY) *
                            context.read<Current>().getcordiY())
                            .round();
                        print(' 선택한점은 절대좌표 X: $debugX, Y: $debugY');
                        setState(() {
                          selectRect= Rect.fromPoints(
                                  Offset(relativeRectPoint.first.x, relativeRectPoint.first.y),
                                  Offset(relativeRectPoint.last.x, relativeRectPoint.last.y));
                        });
                      });
                    }, 
                    child: Stack(
                      children: [
                        Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                        visionText == null
                            ? Container()
                            : Stack(
                          children: visionText.blocks
                              .map(
                                (e) => Positioned.fromRect(
                              rect:
                              Rect.fromPoints(e.boundingBox.topLeft / iS, e.boundingBox.bottomRight / iS),
                              child: InkWell(
                                onLongPress: (){
                                  setState(() {
                                              ocrFinList[visionText.blocks.indexWhere((element) => element == e)] =
                                                  !ocrFinList[visionText.blocks.indexWhere((element) => element == e)];
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
                                                  String tempPath = (await getTemporaryDirectory()).path;
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

                                                  iS =
                                                      decodeImage.width / _keyA.currentContext.size.width;
                                                  ocrFinList = List.filled(visionText.blocks.length, false);
                                                  setState(() {});
                                                });
                                              },
                                            ),
                                          ).toList(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                                color:
                                                ocrFinList[visionText.blocks.indexWhere((element) => element==e)]==false?
                                                Color.fromRGBO(255, 0, 0, 0.3):Color.fromRGBO(0, 255, 0, 0.5),
                                                border: Border.all(color: Colors.red, width: 0.2)),
                                          ),
                              ),
                            ),
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          buildOcrCategorySelect(),
          Row(
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
                child: ElevatedButton(onPressed: (){
                  
                }, child: Text('Room 등록')),
              )
            ],
          ),
          Text(' 선택한점은 절대좌표 X: $debugX, Y: $debugY',textScaleFactor: 2,),
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

  Row buildOcrCategorySelect() {
    return Row(children: [
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
        ],);
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


