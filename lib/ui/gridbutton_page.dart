import 'dart:io';
import 'dart:ui' as ui show Codec, FrameInfo, Image;
import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/data/interiorJson.dart';
import 'package:flutter_app_location_todo/data/interior_index.dart';
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
import 'package:flutter_app_location_todo/ui/label_text_widget.dart';
import 'package:flutter_app_location_todo/ui/task_add_page.dart';
import 'package:flutter_app_location_todo/ui/timview_page.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:provider/provider.dart';

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
  TextEditingController _gridX = TextEditingController();
  TextEditingController _gridY = TextEditingController();
  TextEditingController _task = TextEditingController();
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
  double deviceWidth2;
  num width;
  num heigh;
  Offset selectIntersect = Offset(0, 0);
  Offset realIntersect = Offset(0, 0);
  List<Drawing> drawings = [];
  double _currentSliderValue = 5;
  DateTime _selectedDate;
  DateTime _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();
  ScrollController _controller2 = ScrollController(initialScrollOffset: 560, keepScrollOffset: true);
  ScrollController _gantContrl = ScrollController(initialScrollOffset: 400, keepScrollOffset: true);
  double iS;
  ui.Image decodeImage;
  VisionText visionText;
  DateFormat weekfomat = DateFormat.E();
  DateFormat mdformat = DateFormat('MM.dd');

//   ///
//   DateTime startDate = DateTime.now().subtract(Duration(days: 10));
//   DateTime endDate = DateTime.now().add(Duration(days: 50));
//   DateTime selectedDate = DateTime.now();
//   List<DateTime> markedDates = [
//     DateTime.now().subtract(Duration(days: 1)),
//     DateTime.now().subtract(Duration(days: 2)),
//     DateTime.now().add(Duration(days: 4))
//   ];
//
//   onSelect(data) {
//     print("Selected Date -> $data");
//   }
//
//   onWeekSelect(data) {
//     print("Selected week starting at -> $data");
//   }
//
//   _monthNameWidget(monthName) {
//     return Container(
//       child: Text(monthName,
//           style:
//           TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87, fontStyle: FontStyle.italic)),
//     );
//   }
//
//   getMarkedIndicatorWidget() {
//     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//       Container(
//         margin: EdgeInsets.only(left: 1, right: 1),
//         width: 7,
//         height: 7,
//         decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
//       ),
//       Container(
//         width: 7,
//         height: 7,
//         decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
//       )
//     ]);
//   }
//
//   dateTileBuilder(date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
//     bool isSelectedDate = date.compareTo(selectedDate) == 0;
//     Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
//     TextStyle normalStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
//     TextStyle selectedStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black87);
//     TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
//     List<Widget> _children = [
//       Text(dayName, style: dayNameStyle),
//       Text(date.day.toString(), style: !isSelectedDate ? normalStyle : selectedStyle),
//     ];
//
//     if (isDateMarked == true) {
//       _children.add(getMarkedIndicatorWidget());
//     }
//
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 150),
//       alignment: Alignment.center,
//       padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
//       decoration: BoxDecoration(
//         color: !isSelectedDate ? Colors.transparent : Colors.white70,
//         borderRadius: BorderRadius.all(Radius.circular(60)),
//       ),
//       child: Column(
//         children: _children,
//       ),
//     );
//   }
// ///
  double _lowerValue = DateTime.now().millisecondsSinceEpoch.toDouble();
  double _upperValue = DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch.toDouble();
  Color trackBarColor;
  double _minD = DateTime.now().subtract(Duration(days: 10)).millisecondsSinceEpoch.toDouble();
  double _maxD = DateTime.now().add(Duration(days: 9)).millisecondsSinceEpoch.toDouble();

  DateTime startDay;
  DateTime endDay;
  List<InteriorIndex> interiorList;
  double sLeft;
  double sTop;
  double sRight;
  double sBottom;
  List<int> count = [];
  List<Offset> tracking = [];
  bool callOutLayerOn = false;
  InteriorIndex selectRoom;

  @override
  void initState() {
    super.initState();
    _controller2.addListener(() {
      _gantContrl.jumpTo(_controller2.offset);
    });

    // weekfomat = DateFormat('E');
    // mdformat = DateFormat('MM.dd');

    void readingGrid() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('origingrid').get();
      testgrids = read.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList();
      //그리드를 통한 교차점 확인
      recaculate();
      //TODO 실시간 연동 바운더리
    }

    void readTasks() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('tasks').get();
      tasks = read.docs.map((e) => Task.fromSnapshot(e)).toList();
    }

    readTasks();
    readingGrid();
    print(tasks.length);
    print(testgrids.length);
    _resetSelectedDate();
    Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
    });
    interiorList = interiorIndex.map((e) => InteriorIndex.fromJson(e)).toList();
    selectRoom = interiorList[0];
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(Duration(days: 5));
  }

  @override
  void dispose() {
    super.dispose();
    _pContrl.dispose();
    _gridX.dispose();
    _gridY.dispose();
    _task.dispose();
    _gantContrl.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      deviceWidth = MediaQuery.of(context).size.width;
      width = deviceWidth;
      heigh = deviceWidth / (421 / 297);
      // if(MediaQuery.of(context).orientation == Orientation.portrait){
      //   deviceWidth = MediaQuery.of(context).size.width;
      //   width = deviceWidth;
      //   heigh = deviceWidth / (421 / 297);
      // }
      // else{
      //   deviceWidth = MediaQuery.of(context).size.width;
      //   deviceWidth2 = MediaQuery.of(context).size.height;
      //   heigh = deviceWidth2-40;
      //   width = deviceWidth2*(421 / 297);
      // }
    });
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Scaffold(
            resizeToAvoidBottomPadding: false,
            // appBar: AppBar(
            //   title: Text('그리드 버튼'),
            // ),
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(onPressed: () {
                  setState(() {
                    callOutLayerOn = !callOutLayerOn;
                  });
                })
                // FloatingActionButton(
                //   heroTag: null,
                //   onPressed: () {
                //     print(drawings.length);
                //     print(drawings.where((e) => e.witdh == null).length);
                //     // drawings.where((e) => e.witdh==null).forEach((element) {
                //     //   element.witdh = 421;
                //     //   element.height = 297;
                //     //   FirebaseFirestore.instance.collection('drawing').doc(element.drawingNum).update(element.toJson());
                //     // });
                //     // drawings.where((e) => e.scale==null).forEach((element) {
                //     //   element.scale='1';
                //     //   FirebaseFirestore.instance.collection('drawing').doc(element.drawingNum).update(element.toJson());
                //     // });
                //     //   drawings.forEach((d) {
                //     //   FirebaseFirestore.instance.collection('drawing2').doc(d.drawingNum).set(d.toJson());
                //     //   });
                //   },
                // ),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('origingrid').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SafeArea(child: Center(child: CircularProgressIndicator()));
                return SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // planerSlider(),
                            searchBar(context),
                          ],
                        ),
                        // calendarStrip(),
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
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              buildViewer(context, snapshot),
                            ],
                          ),
                        ),

                        Expanded(
                          child: PageView(
                            controller: PageController(initialPage: 1),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(child: buildAddTaskPage()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(child: buildTaskAddWidget(context)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(child: DetiailResult(selectRoom)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    child: ListView(
                                  children: interiorList
                                      .map((e) => Card(
                                              child: ListTile(
                                            title: AutoSizeText(e.roomName),
                                            leading: Text(e.roomNum),
                                            trailing: Text(e.cLevel),
                                          )))
                                      .toList(),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ));
              },
            ),
          )
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            // appBar: AppBar(
            //   title: Text('그리드 버튼'),
            // ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print(drawings.length);
                print(drawings.where((e) => e.witdh == null).length);

                // drawings.where((e) => e.witdh==null).forEach((element) {
                //   element.witdh = 421;
                //   element.height = 297;
                //   FirebaseFirestore.instance.collection('drawing').doc(element.drawingNum).update(element.toJson());
                // });
                // drawings.where((e) => e.scale==null).forEach((element) {
                //   element.scale='1';
                //   FirebaseFirestore.instance.collection('drawing').doc(element.drawingNum).update(element.toJson());
                // });
                //   drawings.forEach((d) {
                //   FirebaseFirestore.instance.collection('drawing2').doc(d.drawingNum).set(d.toJson());
                //   });
              },
            ),
            // appBar: AppBar(),
            endDrawer: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Drawer(
                  child: buildTaskAddWidget(context),
                )),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('origingrid').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SafeArea(child: Center(child: CircularProgressIndicator()));
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    buildViewer(context, snapshot),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // planerSlider(),
                        Container(width: 300, child: searchBar(context)),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
  }

  Widget buildAddTaskPage() {
    return ListView(
      children: [
        //작업이름, 작업추가 버튼
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child: TextField(
                    controller: _task,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '작업을 입력해주세요',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        tasks.add(Task(DateTime.now(),
                            name: _task.text, boundarys: boundarys.map((e) => e.boundary).toList()));
                        FirebaseFirestore _db = FirebaseFirestore.instance;
                        CollectionReference dbGrid = _db.collection('tasks');
                        dbGrid.doc(_task.text).set(Task(DateTime.now(),
                                name: _task.text,
                                start: startDay,
                                end: endDay,
                                boundarys: boundarys.map((e) => e.boundary).toList())
                            .toJson());
                        _task.text = '';
                        boundarys = [];
                      });
                    },
                    icon: Icon(Icons.check),
                    label: Text('작업추가'),
                  )),
            )
          ],
        ),
        ListTile(
          title: startDay == null
              ? Text('클릭하여 일정을 선택해주세요')
              : Text('일정 : ${DateFormat('yy.MM.d.E').format(startDay)} - ${DateFormat('yy.MM.d.E').format(endDay)}'),
          trailing: startDay == null ? Text('') : Text('기간 ${endDay.difference(startDay).inDays}일'),
          onTap: () {
            setState(() {
              showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2022),
                  builder: (context, Widget child) {
                    return Theme(data: ThemeData.fallback(), child: child);
                  }).then((value) {
                startDay = value.start;
                endDay = value.end;
              });
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(color: Colors.white24),
            child: DropdownSearch<Drawing>(
              validator: (v) => v == null ? "required field" : null,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              items: drawings,
              maxHeight: 400,
              onFind: (String filter) => getData(filter),
              label: "작업자 선택",
              onChanged: (e) {
                setState(() {
                  context.read<Current>().changePath(e);
                  recaculate();
                  setState(() {});
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(color: Colors.white24),
            child: DropdownSearch<Drawing>(
              validator: (v) => v == null ? "required field" : null,
              showSearchBox: true,
              mode: Mode.BOTTOM_SHEET,
              items: drawings,
              maxHeight: 400,
              onFind: (String filter) => getData(filter),
              label: "작업입력",
              onChanged: (e) {
                setState(() {
                  context.read<Current>().changePath(e);
                  recaculate();
                  setState(() {});
                });
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide()),
              hintText: '작업상세사항 입력',
              helperText: '상세사항을 입력해 주세요',
              labelText: 'Tasks',
              prefixIcon: Icon(
                Icons.notes,
              ),
              prefixText: ' ',
            ),
          ),
        )
      ],
    );
  }

  List<DateTime> calendars = List.generate(21, (index) => DateTime.now().add(Duration(days: -10 + index)));

  Widget buildTaskAddWidget(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          controller: _gantContrl,
          scrollDirection: Axis.horizontal,
          //달력간트차트
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: calendars
                .map(
                  (e) => Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              e.weekday == 7
                                  ? Text(weekfomat.format(e), style: TextStyle(color: Colors.red))
                                  : Container(),
                              e.weekday == 6
                                  ? Text(weekfomat.format(e), style: TextStyle(color: Colors.blue))
                                  : Container(),
                              e.weekday != 7 && e.weekday != 6 ? Text(weekfomat.format(e)) : Container(),
                              Text('${e.month}.${e.day}'),
                            ],
                          ),
                        ),
                      ),
                      tasks.where((element) => element.favorite == true).length == 0
                          // ?Container(width: 50,height: 10,color: Colors.red,)
                          ? Container(
                              width: 50,
                              height: 10,
                              color: Colors.blue,
                            )
                          : Column(
                              children: tasks
                                  .where((element) => element.favorite == true && element.start != null)
                                  .map(
                                    (t) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 3,
                                          color:
                                              t.start.isAfter(e) || t.end.isBefore(e) ? Colors.transparent : Colors.red,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        buildTasksList(context),
      ],
    );
  }

  Expanded buildTasksList(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: tasks.map(
              (e) {
                return Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                  child: ListTile(
                    title: Text(e.name),
                    trailing: e.start == null
                        ? Text('일정을 선택해주세요')
                        : Text('${e.start.month}-${e.start.day} ~ ${e.end.month}-${e.end.day}'),
                    // leading: Text(e.boundarys.length.toString()),
                    selected: e.favorite,
                    onTap: () {
                      setState(() {
                        // tasks.singleWhere((element) => element.favorite == true).favorite = false;
                        e.favorite = !e.favorite;
                        print(e.favorite);
                      });
                    },
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(color: Colors.white24),
        child: DropdownSearch<Drawing>(
          validator: (v) => v == null ? "required field" : null,
          showSearchBox: true,
          mode: Mode.BOTTOM_SHEET,
          items: drawings,
          maxHeight: 400,
          onFind: (String filter) => getData(filter),
          label: "도면을 선택해주세요",
          onChanged: (e) {
            setState(() {
              context.read<Current>().changePath(e);
              recaculate();
              setState(() {});
            });
          },
        ),
      ),
    );
  }

  Container buildViewer(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return Container(
      child: AspectRatio(
        key: _key,
        aspectRatio: 421 / 297,
        child: ClipRect(
          child: PhotoView.customChild(
            minScale: 1.0,
            maxScale: 20.0,
            initialScale: 1.0,
            controller: _pContrl,
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
            child: Stack(
              // alignment: Alignment.center,
              children: [
                PositionedTapDetector(
                  onTap: (m) {
                    List<Point<double>> parseList = _iPs
                        .map((e) =>
                            Point(e.dx, e.dy) * deviceWidth +
                            Point(context.read<Current>().getcordiOffset(width, heigh).dx,
                                context.read<Current>().getcordiOffset(width, heigh).dy))
                        .toList();
                    List<Point<double>> realParseList = _realIPs.map((e) => Point(e.dx, e.dy)).toList();

                    setState(() {
                      _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
                      rectPoint = Closet(selectPoint: Point(_origin.dx, _origin.dy), pointList: parseList)
                          .minRect(Point(_origin.dx, _origin.dy));
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
                      print(m.relative / _pContrl.scale);
                      int debugX =
                          (((m.relative.dx / _pContrl.scale) / width - context.read<Current>().getDrawing().originX) *
                                  context.read<Current>().getcordiX())
                              .round();
                      int debugY =
                          (((m.relative.dy / _pContrl.scale) / heigh - context.read<Current>().getDrawing().originY) *
                                  context.read<Current>().getcordiY())
                              .round();
                      print(' 선택한점은 절대좌표 X: $debugX, Y: $debugY');
                      tracking.add(_origin);
                      print(count.length);
                      count.add(tracking.length);
                      setState(() {
                        var _wTime = DateTime.now();
                        boundarys.add(Boundary(_wTime,
                            boundary: Rect.fromPoints(Offset(relativeRectPoint.first.x, relativeRectPoint.first.y),
                                Offset(relativeRectPoint.last.x, relativeRectPoint.last.y))));
                      });
                    });
                  },
                  child: Stack(
                    key: _key2,
                    children: [
                      Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),

                      ///클릭카운터
                      // StreamBuilder<PhotoViewControllerValue>(
                      //   stream: _pContrl.outputStateStream,
                      //   builder: (context, snapshot) {
                      //     if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                      //     return Stack(
                      //       children: [
                      //         CustomPaint(
                      //           painter: CallOutCount(
                      //              tP: tracking,s: snapshot.data.scale),
                      //         ),
                      //         count != []
                      //             ? Stack(
                      //           children: count
                      //               .map((e) => Positioned.fromRect(
                      //               rect: Rect.fromCenter(
                      //                   center: tracking[count.indexOf(e)], width: 100, height: 100),
                      //               child: Center(
                      //                   child: Text(
                      //                     e.toString(),
                      //                     style: TextStyle(color: Colors.white),
                      //                     textScaleFactor: 1/snapshot.data.scale,
                      //                   ))))
                      //               .toList(),
                      //         )
                      //             : Container(),
                      //       ],
                      //     );
                      //   }
                      // ),
                      ///커스텀페인터 그리드 및 교점
                      // context.watch<Current>().getDrawing().scale != '1'
                      //     ? Container(
                      //         child: CustomPaint(
                      //           painter: GridMaker(
                      //             snapshot.data.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList(),
                      //             double.parse(context.watch<Current>().getDrawing().scale) * 421,
                      //             _origin,
                      //             pointList: _iPs,
                      //             deviceWidth: deviceWidth,
                      //             cordinate: context.watch<Current>().getcordiOffset(width, heigh),
                      //           ),
                      //         ),
                      //       )
                      //     : Container(),
                      /// 테스크 바운더리 위젯
                      context.watch<Current>().getDrawing().scale != '1'
                          ? Stack(
                              children: tasks
                                  .map((e) => Stack(
                                        children: e.boundarys.map(
                                          (b) {
                                            var watch = context.watch<Current>();
                                            return Positioned.fromRect(
                                              rect: Rect.fromPoints(
                                                  Offset(
                                                    b.bottomRight.dx / (watch.getcordiX() / width) +
                                                        (watch.getDrawing().originX * width),
                                                    b.bottomRight.dy / (watch.getcordiY() / heigh) +
                                                        ((watch.getDrawing().originY * heigh)),
                                                  ),
                                                  Offset(
                                                    b.topLeft.dx / (watch.getcordiX() / width) +
                                                        (watch.getDrawing().originX * width),
                                                    b.topLeft.dy / (watch.getcordiY() / heigh) +
                                                        ((watch.getDrawing().originY * heigh)),
                                                  )),
                                              child: GestureDetector(
                                                onLongPress: () {
                                                  List<Task> _tempList =
                                                      tasks.where((e) => e.boundarys.contains(b)).toList();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => BoundayDetail(_tempList)),
                                                  );
                                                },
                                                child: Container(
                                                  color: e.favorite == false
                                                      ? Colors.black12
                                                      : Color.fromRGBO(255, 0, 0, 0.5),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      tasks.where((e) => e.boundarys.contains(b)).length.toString(),
                                                      textScaleFactor: 0.7,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ))
                                  .toList())
                          : Container(),

                      /// 선택한 바운더리 위젯
                      ...boundarys.map(
                        (e) {
                          var watch = context.watch<Current>();
                          return Positioned.fromRect(
                            rect: Rect.fromPoints(
                                Offset(
                                  e.boundary.bottomRight.dx / (watch.getcordiX() / width) +
                                      (watch.getDrawing().originX * width),
                                  e.boundary.bottomRight.dy / (watch.getcordiY() / heigh) +
                                      ((watch.getDrawing().originY * heigh)),
                                ),
                                Offset(
                                  e.boundary.topLeft.dx / (watch.getcordiX() / width) +
                                      (watch.getDrawing().originX * width),
                                  e.boundary.topLeft.dy / (watch.getcordiY() / heigh) +
                                      ((watch.getDrawing().originY * heigh)),
                                )),
                            child: Opacity(
                              opacity: 0.5,
                              child: ElevatedButton(
                                onLongPress: () {
                                  setState(() {
                                    List<Task> _boundaryTask = e.tasksList;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => BoundayDetail(_boundaryTask)),
                                    );
                                  });
                                },
                                onPressed: () {
                                  setState(() {
                                    boundarys.remove(e);
                                  });
                                  print(e.writeTime.toString());
                                },
                                child: null,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // 도면 정보 스케일 위젯
                      ///도면 상세정보
                      // StreamBuilder<PhotoViewControllerValue>(
                      //     stream: _pContrl.outputStateStream,
                      //     builder: (context, snapshot) {
                      //       if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                      //       return snapshot.data.scale < 12 ? planInfo(context) : detailInfo(context);
                      //     }),
                      ///CallOut 바운더리 구현
                      callOutLayerOn == true
                          ? Stack(
                              children: context.watch<Current>().getDrawing().callOutMap.map((e) {
                                double l = e['bLeft'] / context.watch<Current>().getcordiX() * deviceWidth;
                                double t = e['bTop'] / context.watch<Current>().getcordiX() * deviceWidth;
                                double r = e['bRight'] / context.watch<Current>().getcordiX() * deviceWidth;
                                double b = e['bBottom'] / context.watch<Current>().getcordiX() * deviceWidth;
                                double x = context.watch<Current>().getcordiOffset(width, heigh).dx;
                                double y = context.watch<Current>().getcordiOffset(width, heigh).dy;
                                return Positioned.fromRect(
                                  rect: Rect.fromLTRB(
                                    l + x,
                                    t + y,
                                    r + x,
                                    b + y,
                                  ),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      callOutLayerOn = false;
                                      count = [];
                                      tracking = [];
                                      Drawing select = drawings.singleWhere((v) => v.drawingNum == e['name']);
                                      context.read<Current>().changePath(select);
                                      recaculate();
                                      setState(() {});
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Color.fromRGBO(255, 0, 0, 0.15),
                                        child: Center(
                                            child: AutoSizeText(
                                          e['name'],
                                          maxLines: 1,
                                          minFontSize: 0,
                                          // minFontSize: ,
                                        )),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : Container(),

                      ///RoomTag구현
                      callOutLayerOn == true
                          ? Stack(
                              children: context.watch<Current>().getDrawing().roomMap.map((e) {
                                double l = e['bLeft'] / context.watch<Current>().getcordiX() * deviceWidth;
                                double t = e['bTop'] / context.watch<Current>().getcordiX() * deviceWidth;
                                double r = e['bRight'] / context.watch<Current>().getcordiX() * deviceWidth;
                                double b = e['bBottom'] / context.watch<Current>().getcordiX() * deviceWidth;
                                double x = context.watch<Current>().getcordiOffset(width, heigh).dx;
                                double y = context.watch<Current>().getcordiOffset(width, heigh).dy;
                                return Positioned.fromRect(
                                  rect: Rect.fromLTRB(
                                    l + x,
                                    t + y,
                                    r + x,
                                    b + y,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        print(e['name']);
                                        selectRoom = interiorList.singleWhere((r) => r.roomNum.contains(e['id']));
                                      });
                                    },
                                    child: Container(
                                      color: Color.fromRGBO(0, 0, 255, 0.3),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding planerSlider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlutterSlider(
        handlerHeight: 25,
        trackBar: FlutterSliderTrackBar(activeTrackBar: BoxDecoration(color: trackBarColor)),
        handler:
            FlutterSliderHandler(child: Text(DateTime.fromMillisecondsSinceEpoch(_lowerValue.toInt()).day.toString())),
        // hatchMark: FlutterSliderHatchMark(
        //   density: 0.142857143,
        //   bigLine: FlutterSliderSizedBox(height: 50, width: 1,decoration:BoxDecoration(color: Colors.red) ),
        //   smallLine: FlutterSliderSizedBox(height: 50, width: 1,decoration:BoxDecoration(color: Colors.red) ),
        //   linesDistanceFromTrackBar: 5,
        //   displayLines: true
        // ),
        values: [
          _lowerValue,
          // _upperValue,
        ],
        // minimumDistance: DateTim,
        min: _minD,
        max: _maxD,
        // rangeSlider: false,
        jump: true,
        step: FlutterSliderStep(step: 86400000),
        // rangeSlider: true,
        centeredOrigin: true,
        tooltip: FlutterSliderTooltip(custom: (value) {
          DateTime dtValue = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          String valueInTime = dtValue.month.toString() + '.' + dtValue.day.toString();
          return Text(valueInTime);
        }),
        onDragging: (handlerIndex, lowerValue, upperValue) {
          if (lowerValue > DateTime.now().millisecondsSinceEpoch) {
            trackBarColor = Colors.blueAccent;
          } else {
            trackBarColor = Colors.redAccent;
          }
          _lowerValue = lowerValue;
          // _upperValue = upperValue;
          print(DateTime.fromMillisecondsSinceEpoch(_lowerValue.toInt()));
          print(_lowerValue);
          setState(() {});
        },
      ),
    );
  }

  Stack detailInfo(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: drawings.singleWhere((d) => d.drawingNum == 'A31-109').detailInfoMap.map((e) {
            double tempX = e['x'] / (500 * 421.0) * deviceWidth;
            double tempY = e['y'] / (500 * 297.0) * heigh;
            return Positioned(
                left: tempX + context.watch<Current>().getcordiOffset(width, heigh).dx,
                top: tempY + context.watch<Current>().getcordiOffset(width, heigh).dy,
                child: Text(
                  '${e['name']}',
                  textScaleFactor: 0.1,
                ));
          }).toList(),
        ),
        Stack(
          children: drawings.singleWhere((d) => d.drawingNum == 'A31-110').detailInfoMap.map((e) {
            double tempX = e['x'] / (500 * 421.0) * deviceWidth;
            double tempY = e['y'] / (500 * 297.0) * heigh;
            return Positioned(
                left: tempX + context.watch<Current>().getcordiOffset(width, heigh).dx,
                top: tempY + context.watch<Current>().getcordiOffset(width, heigh).dy,
                child: Text(
                  '${e['name']}',
                  textScaleFactor: 0.1,
                ));
          }).toList(),
        ),
        Stack(
          children: drawings.singleWhere((d) => d.drawingNum == 'A31-111').detailInfoMap.map((e) {
            double tempX = e['x'] / (500 * 421.0) * deviceWidth;
            double tempY = e['y'] / (500 * 297.0) * heigh;
            return Positioned(
                left: tempX + context.watch<Current>().getcordiOffset(width, heigh).dx,
                top: tempY + context.watch<Current>().getcordiOffset(width, heigh).dy,
                child: Text(
                  '${e['name']}',
                  textScaleFactor: 0.1,
                ));
          }).toList(),
        ),
        Stack(
          children: drawings.singleWhere((d) => d.drawingNum == 'A31-112').detailInfoMap.map((e) {
            double tempX = e['x'] / (500 * 421.0) * deviceWidth;
            double tempY = e['y'] / (500 * 297.0) * heigh;
            return Positioned(
                left: tempX + context.watch<Current>().getcordiOffset(width, heigh).dx,
                top: tempY + context.watch<Current>().getcordiOffset(width, heigh).dy,
                child: Text(
                  '${e['name']}',
                  textScaleFactor: 0.1,
                ));
          }).toList(),
        ),
      ],
    );
  }

  Stack planInfo(BuildContext context) {
    return Stack(
      children: context.watch<Current>().getDrawing().detailInfoMap.map((e) {
        double tempX = e['x'] / (double.parse(context.watch<Current>().getDrawing().scale) * 421.0) * deviceWidth;
        double tempY = e['y'] / (double.parse(context.watch<Current>().getDrawing().scale) * 297.0) * heigh;
        return Positioned(
            left: tempX + context.watch<Current>().getcordiOffset(width, heigh).dx,
            top: tempY + context.watch<Current>().getcordiOffset(width, heigh).dy,
            child: Text(
              '${e['name']}',
              textScaleFactor: 0.2,
            ));
      }).toList(),
    );
  }

  void reaSelectIntersect() {
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

  customHandler(IconData icon) {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Container(
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle),
          child: Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.blue.withOpacity(0.3), spreadRadius: 0.05, blurRadius: 5, offset: Offset(0, 1))
          ],
        ),
      ),
    );
  }
}

class DetiailResult extends StatelessWidget {
  InteriorIndex input;

  DetiailResult(this.input);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: Text(input.roomNum),
            title: Text(input.roomName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('실내재료 마감상세도'),
                            content: Column(
                              children: [
                                Image.asset('asset/detailRoom.png'),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('마감상세도'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columns: [
                DataColumn(label: Text('구분')),
                DataColumn(label: Text('바탕')),
                DataColumn(label: Text('마감')),
                DataColumn(label: Text('Thk/Level')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('바닥')),
                    DataCell(Text(input.fBackground)),
                    DataCell(Text(input.fFin)),
                    DataCell(Text(input.fThk)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('걸레받이')),
                    DataCell(Text(input.bBBackground)),
                    DataCell(Text(input.bBFin)),
                    DataCell(Text(input.bBThk)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('벽')),
                    DataCell(Text(input.wBackground)),
                    DataCell(Text(input.wFin)),
                    DataCell(Text('-')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('천정')),
                    DataCell(Text(input.cBackground)),
                    DataCell(Text(input.cFin)),
                    DataCell(Text(input.cLevel)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CallOutCount extends CustomPainter {
  List<Offset> tP;
  double s = 1;

  CallOutCount({this.tP, this.s});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint4 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25.0 / s
      ..color = Color.fromRGBO(255, 0, 0, 1);
    Paint paint5 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0 / s
      ..color = Color.fromRGBO(255, 0, 0, 1);

    tP == [] ? null : canvas.drawPoints(PointMode.points, tP, paint4);
    tP == [] ? null : canvas.drawPoints(PointMode.polygon, tP, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
