// import 'dart:js';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/data/local_list.dart';
import 'package:flutter_app_location_todo/model/IntersectionPoint.dart';
import 'package:flutter_app_location_todo/model/boundary_model.dart';
import 'package:flutter_app_location_todo/model/closest_model.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/grid_model.dart';
import 'package:flutter_app_location_todo/model/gridtest_model.dart';
import 'package:flutter_app_location_todo/model/line_model.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/ui/boundary_detail_page.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';


class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Grid> grids = [];
  List<Gridtestmodel> testgrids = [];
  Offset _origin = Offset(0, 0);

  //TODO 도면의 스케일 값을 지정해줘야됨
  TextEditingController _gridX = TextEditingController();
  TextEditingController _gridY = TextEditingController();
  TextEditingController _task = TextEditingController();
  TextEditingController _floorEditor = TextEditingController();
  TextEditingController _scaleEditor = TextEditingController();
  List<Offset> _iPs;
  List<Offset> _realIPs;
  List<Point> rectPoint = [];
  List<Point> relativeRectPoint = [];
  List<Boundary> boundarys = [];
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
  double _currentSliderValue = 5;


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
    void readTasks()async{
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('tasks').get();
      tasks = read.docs.map((e) => Task.fromSnapshot(e)).toList();
    }

    readTasks();
    readingGrid();
    Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
    });

  }

  void dispose() {
    super.dispose();
    _pContrl.dispose();
    _gridX.dispose();
    _gridY.dispose();
    _task.dispose();
    _floorEditor.dispose();
    _scaleEditor.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      deviceWidth = MediaQuery.of(context).size.width;
      width = deviceWidth;
      heigh = deviceWidth / (421 / 297);
    });
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('그리드 버튼'),
          actions: [
            InkWell(
                onTap: () {
                  print(tasks[0].boundarys);
                  print(testgrids.length);
                },
                child: Icon(Icons.add)),
            IconButton(icon: Icon(Icons.cloud_upload), onPressed: (){})
          ],
        ),
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
                        Container(
                          child: AspectRatio(
                            key: _key,
                            aspectRatio: 421 / 297,
                            child: ClipRect(
                              child: PhotoView.customChild(
                                minScale: 1.0,
                                maxScale: 10.0,
                                initialScale: 1.0,
                                controller: _pContrl,
                                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                child: Stack(
                                  children: [
                                    PositionedTapDetector(
                                      onLongPress: (m) {
                                        ///TODO 원점 재지정 좌표 메서드
                                        setState(() {
                                          context.read<Current>().getDrawing().originX =
                                              (m.relative.dx / (width * _pContrl.scale)) -
                                                  (realIntersect.dx / context.read<Current>().getcordiX());
                                          context.read<Current>().getDrawing().originY =
                                              (m.relative.dy / (heigh * _pContrl.scale)) -
                                                  (realIntersect.dy / context.read<Current>().getcordiY());
                                          print(
                                              '${context.read<Current>().getDrawing().originX}, ${context.read<Current>().getDrawing().originY}');
                                        });
                                      },
                                      child: Stack(
                                        key: _key2,
                                        children: [
                                          Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
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
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _floorEditor,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Floor',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _scaleEditor,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Scale',
                                    ),
                                  ),
                                ),
                              ),
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
                                    autofocus: true,
                                    onPressed: () {
                                      setState(() {
                                        Drawing tempModel = context.read<Current>().getDrawing();
                                            FirebaseFirestore.instance.collection('drawing').doc(tempModel.drawingNum).update(tempModel.toJson());
                                      });
                                    },
                                    child: Text('업로드'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                            Text('S $selectIntersect, R $realIntersect',textScaleFactor: 1.5,),

                            Text(context.watch<Current>().getcordi(),textScaleFactor: 1.5,),
                          Expanded(
                            child: ListView(
                              children: drawings
                                  .map(
                                    (e) => ListTile(
                                      title: Text(e.toString()),
                                      onTap:()=>context.read<Current>().changePath(e)
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  void reaSelectIntersect() {
    context.read<Current>().getDrawing().scale=_scaleEditor.text;
    context.read<Current>().getDrawing().floor=int.parse(_floorEditor.text);
    context.read<Current>().getDrawing().witdh=421;
    context.read<Current>().getDrawing().height=297;
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
