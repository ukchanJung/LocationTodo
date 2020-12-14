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


class Dmap extends StatefulWidget {
  @override
  _DmapState createState() => _DmapState();
}

class _DmapState extends State<Dmap> {
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
      body: Column(
        children: [
          Container(height: 50,),
          Divider(),
          Text('절대좌표 X: $debugX, Y: $debugY',textScaleFactor: 2,),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownSearch<Drawing>(
              items: drawings,
              maxHeight: 600,
              // onFind: (String filter) => getData(filter),
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
          Container(
            height: 700,
            child: ClipRect(
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
                      debugX = (((m.relative.dx / _pContrl.scale) / width -
                          context.read<Current>().getDrawing().originX) *
                          context.read<Current>().getcordiX())
                          .round();
                      debugY = (((m.relative.dy / _pContrl.scale) / heigh -
                          context.read<Current>().getDrawing().originY) *
                          context.read<Current>().getcordiY())
                          .round();
                      print(' 선택한점은 절대좌표 X: $debugX, Y: $debugY');
                    });
                  },
                  child: Stack(
                    children: [
                      Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                      context.watch<Current>().getDrawing().roomMap == [] ||visionText == null
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
                    ],
                  ),
                ),
              ),
            ),
          ),
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


