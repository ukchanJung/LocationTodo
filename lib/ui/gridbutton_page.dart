import 'dart:io';
import 'dart:ui' as ui show Codec, FrameInfo, Image;
import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
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
import 'package:flutter_app_location_todo/ui/crosshair_paint.dart';
import 'package:flutter_app_location_todo/ui/label_text_widget.dart';
import 'package:flutter_app_location_todo/ui/task_add_page.dart';
import 'package:flutter_app_location_todo/ui/timview_page.dart';
import 'package:flutter_app_location_todo/widget/gridmaker_widget.dart';
import 'package:flutter_app_location_todo/widget/searchdialog_widget.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
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
  double deviceWidth2;
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

  List<Offset> measurement;
  List<Offset> rmeasurement;
  bool taskAdd = true;

  ScrollController gantControl = ScrollController();
  List<Drawing> pathDrawings = [];
  double keyX = 0.0;
  double keyY = 0.0;
  PhotoViewScaleStateController _scaleStateController = PhotoViewScaleStateController();
  bool moving = false;
  List<GridIcon> bb = [];
  Offset hover = Offset.zero;
  Offset _offset =Offset.zero;
  Offset _origin2 = Offset.zero;
  bool oribit1 =false;
  bool oribit2 =false;

  @override
  void initState() {
    super.initState();
    _gantContrl.addListener(() {
      gantControl.jumpTo(_gantContrl.offset);
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
      context.read<Current>().changePath(drawings.singleWhere((d) => d.drawingNum == 'A31-003'));
      pathDrawings.add(context.read<Current>().getDrawing());
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
    _scaleStateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Scaffold(
            resizeToAvoidBottomPadding: false,
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('origingrid').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SafeArea(child: Center(child: CircularProgressIndicator()));
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LayoutBuilder(builder: (context, colC) {
                      return Container(
                        width: colC.maxWidth,
                        height: colC.maxWidth / (420 / 297),
                        child: LayoutBuilder(builder: (context, c) {
                          _pContrl.addIgnorableListener(() {
                            keyX = _pContrl.value.position.dx / (c.maxWidth * _pContrl.value.scale);
                            keyY = _pContrl.value.position.dy / (c.maxHeight * _pContrl.value.scale);
                          });
                          return Listener(
                            onPointerDown: (_){
                              setState(() {
                              moving = true;
                              });
                            },
                            onPointerUp: (_){
                              setState(() {
                              moving = false;
                              });
                            },
                            onPointerSignal: (m) {
                              if (m is PointerScrollEvent) {
                                double tempset = _pContrl.scale - 1;
                                Offset up = Offset(keyX * c.maxWidth * (_pContrl.scale + 0.2),
                                    keyY * c.maxHeight * (_pContrl.scale + 0.2));
                                Offset dn = Offset(keyX * c.maxWidth * (_pContrl.scale - 0.2),
                                    keyY * c.maxHeight * (_pContrl.scale - 0.2));
                                if (m.scrollDelta.dy > 1 && _pContrl.scale > 1) {
                                  _pContrl.value = PhotoViewControllerValue(
                                      position: dn,
                                      scale: (_pContrl.scale - 0.2),
                                      rotation: 0,
                                      rotationFocusPoint: null);
                                } else if (m.scrollDelta.dy < 1) {
                                  _pContrl.value = PhotoViewControllerValue(
                                      position: up,
                                      scale: (_pContrl.scale + 0.2),
                                      rotation: 0,
                                      rotationFocusPoint: null);
                                }
                              }
                              ;
                            },
                            child: buildViewer(context, snapshot, c),
                          );
                        }),
                      );
                    }),
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
                            child: Card(child: buildDrawingPath()),
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
                );
              },
            ),
          )
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            // appBar: AppBar(
            //   title: Text('그리드 버튼'),
            // ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            _offset = Offset.zero;
          });
        },
      ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('origingrid').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SafeArea(child: Center(child: CircularProgressIndicator()));
                return Row(
                  children: [
                    LayoutBuilder(builder: (context, rowC) {
                      return Container(
                        width: rowC.maxHeight * (420 / 297),
                        height: rowC.maxHeight,
                        child: LayoutBuilder(builder: (context, c) {
                          _pContrl.addIgnorableListener(() {
                            keyX = _pContrl.value.position.dx / (c.maxWidth * _pContrl.value.scale);
                            keyY = _pContrl.value.position.dy / (c.maxHeight * _pContrl.value.scale);
                          });
                          return Listener(
                            onPointerDown: (_){
                              setState(() {
                                moving = true;
                              });
                            },
                            onPointerUp: (_){
                              setState(() {
                                moving = false;
                              });
                            },
                            onPointerSignal: (m) {
                              if (m is PointerScrollEvent) {
                                Offset up = Offset(keyX * c.maxWidth * (_pContrl.scale + 0.2),
                                    keyY * c.maxHeight * (_pContrl.scale + 0.2));
                                Offset dn = Offset(keyX * c.maxWidth * (_pContrl.scale - 0.2),
                                    keyY * c.maxHeight * (_pContrl.scale - 0.2));
                                if (m.scrollDelta.dy > 1 && _pContrl.scale > 1) {
                                  _pContrl.value = PhotoViewControllerValue(
                                      position: dn,
                                      scale: (_pContrl.scale - 0.2),
                                      rotation: 0,
                                      rotationFocusPoint: null);
                                } else if (m.scrollDelta.dy < 1) {
                                  _pContrl.value = PhotoViewControllerValue(
                                      position: up,
                                      scale: (_pContrl.scale + 0.2),
                                      rotation: 0,
                                      rotationFocusPoint: null);
                                }
                              }
                              ;
                            },
                            child: RawKeyboardListener(
                              autofocus: true,
                              focusNode: FocusNode(),
                              onKey: (k){
                                setState(() {
                                  oribit1 = k.isShiftPressed;
                                });
                              },
                              child: Listener(
                                onPointerDown: (o){
                                  if(oribit1){
                                    setState(() {
                                      _origin2 =o.position;
                                      print('#######$_origin2');
                                    });
                                  }
                                },
                                onPointerHover: (h){
                                  if(oribit1){
                                    setState(() {
                                      _offset += h.delta;
                                    });
                                  }
                                },
                                child: buildViewer(context, snapshot, c),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                    Expanded(
                      child: Column(
                        children: [
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
                          LayoutBuilder(
                            builder: (context, keymap) {
                              return Container(
                                height: keymap.maxWidth/(420/297)+50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(child: buildDrawingPath()),
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
  }

  Widget buildDrawingPath() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: context
                    .read<Current>()
                    .pattern
                    .reversed
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                context.read<Current>().changePath(e);
                                Get.defaultDialog(title: e.toString(), actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<Current>().addFavorite(e);
                                    },
                                    child: Text('즐겨찾기'),
                                  )
                                ]);
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                context.read<Current>().pattern.remove(e);
                              });
                            },
                            child: Chip(
                              avatar: CircleAvatar(child: Text(e.drawingNum[0])),
                              label: Text(e.title),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          LayoutBuilder(builder: (context, k) {
            return StreamBuilder<PhotoViewControllerValue>(
                stream: _pContrl.outputStateStream,
                initialData: PhotoViewControllerValue(
                  position: _pContrl.position,
                  rotation: 0,
                  rotationFocusPoint: null,
                  scale: _pContrl.scale,
                ),
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),
                      Positioned(
                        left: -keyX * k.maxWidth,
                        top: -keyY * k.maxWidth / (420 / 297),
                        child: Transform.scale(
                            scale: 1 / snapshot.data.scale,
                            child: Container(
                              width: k.maxWidth,
                              height: k.maxWidth / (420 / 297),
                              color: Color.fromRGBO(255, 0, 0, 0.5),
                            )),
                      )
                    ],
                  );
                });
          }),
        ],
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
                        tasks.add(
                          Task(DateTime.now(),
                              name: _task.text,
                              start: startDay,
                              end: endDay,
                              boundarys: boundarys.map((e) => e.boundary).toList(),
                              z: context.read<Current>().getDrawing().floor),
                        );
                        FirebaseFirestore _db = FirebaseFirestore.instance;
                        CollectionReference dbGrid = _db.collection('tasks');
                        dbGrid.doc(_task.text).set(
                              Task(
                                DateTime.now(),
                                name: _task.text,
                                start: startDay,
                                end: endDay,
                                boundarys: boundarys.map((e) => e.boundary).toList(),
                                z: context.read<Current>().getDrawing().floor,
                              ).toJson(),
                            );
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

  List<DateTime> calendars = List.generate(21, (index) => DateTime.now().add(Duration(days: -20 + index)));

  Widget buildTaskAddWidget(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          controller: _gantContrl,
          scrollDirection: Axis.horizontal,
          //달력간트차트
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: calendars
                .map(
                  (e) => Container(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          e.weekday == 7 ? Text(weekfomat.format(e), style: TextStyle(color: Colors.red)) : Container(),
                          e.weekday == 6
                              ? Text(weekfomat.format(e), style: TextStyle(color: Colors.blue))
                              : Container(),
                          e.weekday != 7 && e.weekday != 6 ? Text(weekfomat.format(e)) : Container(),
                          Text('${e.month}.${e.day}'),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        buildTasksList(context),
      ],
    );
  }

  Widget buildTasksList(BuildContext context) {
    return Container(
      child: Expanded(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: tasks.where((t) => t.floor == context.watch<Current>().getDrawing().floor).map((e) {
                return Container(
                  // decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        controller: gantControl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: calendars
                              .map((d) => Container(
                                    width: 50,
                                    height: 3,
                                    color: e.start.isAfter(d.add(Duration(days: 1))) || e.end.isBefore(d)
                                        ? Colors.transparent
                                        : Colors.red,
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildViewer(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, BoxConstraints c) {
    return Stack(
      children: [
        Container(
          child: ClipRect(
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateZ(0)
                ..rotateX(0.005*_offset.dy)
                ..rotateY(0),
              origin: _origin2,
              child: PhotoView.customChild(
                minScale: 1.0,
                maxScale: 20.0,
                initialScale: 1.0,
                controller: _pContrl,
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                child: LayoutBuilder(
                  builder: (context, k) {
                    return Stack(
                      children: [
                        PositionedTapDetector(
                          key: _key,
                          onTap: (m) {
                            List<Point<double>> parseList = _iPs
                                .map((e) =>
                                    Point(e.dx, e.dy) * c.maxWidth +
                                    Point(context.read<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dx,
                                        context.read<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dy))
                                .toList();
                            List<Point<double>> realParseList = _realIPs.map((e) => Point(e.dx, e.dy)).toList();

                            setState(() {
                              _origin = Offset(m.relative.dx, m.relative.dy) / _pContrl.scale;
                              rectPoint = Closet(selectPoint: Point(_origin.dx, _origin.dy), pointList: parseList)
                                  .minRect(Point(_origin.dx, _origin.dy));
                              relativeRectPoint = Closet(
                                      selectPoint: Point(
                                          (((m.relative.dx / _pContrl.scale) / c.maxWidth -
                                                  context.read<Current>().getDrawing().originX) *
                                              context.read<Current>().getcordiX()),
                                          (((m.relative.dy / _pContrl.scale) / c.maxHeight -
                                                  context.read<Current>().getDrawing().originY) *
                                              context.read<Current>().getcordiY())),
                                      pointList: realParseList)
                                  .minRect(Point(
                                      (((m.relative.dx / _pContrl.scale) / c.maxWidth -
                                              context.read<Current>().getDrawing().originX) *
                                          context.read<Current>().getcordiX()),
                                      (((m.relative.dy / _pContrl.scale) / c.maxHeight -
                                              context.read<Current>().getDrawing().originY) *
                                          context.read<Current>().getcordiY())));
                              print(m.relative / _pContrl.scale);
                              int debugX = (((m.relative.dx / _pContrl.scale) / c.maxWidth -
                                          context.read<Current>().getDrawing().originX) *
                                      context.read<Current>().getcordiX())
                                  .round();
                              int debugY = (((m.relative.dy / _pContrl.scale) / c.maxHeight -
                                          context.read<Current>().getDrawing().originY) *
                                      context.read<Current>().getcordiY())
                                  .round();
                              print(' 선택한점은 절대좌표 X: $debugX, Y: $debugY');
                              tracking.add(_origin);
                              print(count.length);
                              count.add(tracking.length);
                              measurement.add(_origin);
                              rmeasurement.add(Offset(debugX.toDouble(), debugY.toDouble()));

                              setState(() {
                                var _wTime = DateTime.now();
                                boundarys.add(Boundary(_wTime,
                                    boundary: Rect.fromPoints(Offset(relativeRectPoint.first.x, relativeRectPoint.first.y),
                                        Offset(relativeRectPoint.last.x, relativeRectPoint.last.y))));
                              });
                            });
                          },
                          child: Listener(
                            onPointerHover: (h){
                              setState(() {
                                hover = h.localPosition;
                              });
                            },
                            child: Stack(
                              key: _key2,
                              children: [
                                Image.asset('asset/photos/${context.watch<Current>().getDrawing().localPath}'),

                                ///측정구현
                                taskAdd == true
                                    ? Container()
                                  : StreamBuilder<PhotoViewControllerValue>(
                                      stream: _pContrl.outputStateStream,
                                    initialData: PhotoViewControllerValue(
                                      position: _pContrl.position,
                                      rotation: 0,
                                      rotationFocusPoint: null,
                                      scale: _pContrl.scale,
                                    ),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                                        return Stack(
                                          children: [
                                            CustomPaint(
                                              painter: CallOutCount(tP: tracking, s: snapshot.data.scale),
                                            ),
                                            // count != []
                                            //     ? Stack(
                                            //   children: count
                                            //       .map((e) => Positioned.fromRect(
                                            //       rect: Rect.fromCenter(
                                            //           center: tracking[count.indexOf(e)], width: 100, height: 100),
                                            //       child: Center(
                                            //           child: Text(
                                            //             e.toString(),
                                            //             style: TextStyle(color: Colors.white),
                                            //             textScaleFactor: 1/snapshot.data.scale,
                                            //           ))))
                                            //       .toList(),
                                            // )
                                            //     : Container(),
                                            measurement != null && measurement.length > 1
                                                ? Stack(
                                                    children: measurement
                                                        .sublist(1)
                                                        .map((e) => Positioned.fromRect(
                                                            rect: Rect.fromCenter(
                                                                center: (measurement[measurement.indexOf(e) - 1] +
                                                                        measurement[measurement.indexOf(e)]) /
                                                                    2,
                                                                width: 100,
                                                                height: 100),
                                                            child: Center(
                                                                child: Transform.rotate(
                                                              angle: pi /
                                                                  (180 /
                                                                      Line(measurement[measurement.indexOf(e) - 1],
                                                                              measurement[measurement.indexOf(e)])
                                                                          .degree()),
                                                              child: Text(
                                                                  '${(Line(rmeasurement[measurement.indexOf(e) - 1], rmeasurement[measurement.indexOf(e)]).length() / 1000).toStringAsFixed(2)}'
                                                                  // style: TextStyle(color: Colors.white),
                                                                  ),
                                                            ))))
                                                        .toList(),
                                                  )
                                                : Container(),
                                          ],
                                        );
                                      }),

                              ///커스텀페인터 그리드 및 교점
                                // context.watch<Current>().getDrawing().scale != '1'
                                //     ? Container(
                                //         child: StreamBuilder<PhotoViewControllerValue>(
                                //           stream: _pContrl.outputStateStream,
                                //                 initialData: PhotoViewControllerValue(
                                //                   position: Offset(0,0),
                                //                   rotation: 0,
                                //                   rotationFocusPoint: null,
                                //                   scale: 1,
                                //                 ),
                                //             builder: (context, snapshot2) {
                                //             return CustomPaint(
                                //               painter: GridMaker(
                                //                 snapshot.data.docs.map((e) => Gridtestmodel.fromSnapshot(e)).toList(),
                                //                 double.parse(context.watch<Current>().getDrawing().scale) * 421,
                                //                 _origin,
                                //                 pointList: _iPs,
                                //                 deviceWidth: c.maxWidth,
                                //                 cordinate: context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight),
                                //                 sS: snapshot2.data.scale,
                                //                 x: keyX*c.maxWidth,
                                //                 y: keyY*c.maxHeight ,
                                //               ),
                                //             );
                                //           }
                                //         ),
                                //       )
                                //     : Container(),

                                /// 테스크 바운더리 위젯
                                context.watch<Current>().getDrawing().scale != '1'
                                    ? Stack(
                                        children: tasks
                                            .where((t) => t.floor == context.watch<Current>().getDrawing().floor)
                                            .map((e) => Stack(
                                                  children: e.boundarys.map(
                                                    (b) {
                                                      var watch = context.watch<Current>();
                                                      return Positioned.fromRect(
                                                        rect: Rect.fromPoints(
                                                            Offset(
                                                              b.bottomRight.dx / (watch.getcordiX() / c.maxWidth) +
                                                                  (watch.getDrawing().originX * c.maxWidth),
                                                              b.bottomRight.dy / (watch.getcordiY() / c.maxHeight) +
                                                                  ((watch.getDrawing().originY * c.maxHeight)),
                                                            ),
                                                            Offset(
                                                              b.topLeft.dx / (watch.getcordiX() / c.maxWidth) +
                                                                  (watch.getDrawing().originX * c.maxWidth),
                                                              b.topLeft.dy / (watch.getcordiY() / c.maxHeight) +
                                                                  ((watch.getDrawing().originY * c.maxHeight)),
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
                                taskAdd != true
                                    ? Container()
                                    : Stack(
                                        children: boundarys.map(
                                        (e) {
                                          var watch = context.watch<Current>();
                                          return Positioned.fromRect(
                                            rect: Rect.fromPoints(
                                                Offset(
                                                  e.boundary.bottomRight.dx / (watch.getcordiX() / c.maxWidth) +
                                                      (watch.getDrawing().originX * c.maxWidth),
                                                  e.boundary.bottomRight.dy / (watch.getcordiY() / c.maxHeight) +
                                                      ((watch.getDrawing().originY * c.maxHeight)),
                                                ),
                                                Offset(
                                                  e.boundary.topLeft.dx / (watch.getcordiX() / c.maxWidth) +
                                                      (watch.getDrawing().originX * c.maxWidth),
                                                  e.boundary.topLeft.dy / (watch.getcordiY() / c.maxHeight) +
                                                      ((watch.getDrawing().originY * c.maxHeight)),
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
                                      ).toList()),

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
                                          double l = e['bLeft'] / context.watch<Current>().getcordiX() * c.maxWidth;
                                          double t = e['bTop'] / context.watch<Current>().getcordiX() * c.maxWidth;
                                          double r = e['bRight'] / context.watch<Current>().getcordiX() * c.maxWidth;
                                          double b = e['bBottom'] / context.watch<Current>().getcordiX() * c.maxWidth;
                                          double x = context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dx;
                                          double y = context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dy;
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
                                          double l = e['bLeft'] / context.watch<Current>().getcordiX() * c.maxWidth;
                                          double t = e['bTop'] / context.watch<Current>().getcordiX() * c.maxWidth;
                                          double r = e['bRight'] / context.watch<Current>().getcordiX() * c.maxWidth;
                                          double b = e['bBottom'] / context.watch<Current>().getcordiX() * c.maxWidth;
                                          double x = context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dx;
                                          double y = context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dy;
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
                                CustomPaint(
                                  painter: CrossHairPaint(hover),
                                  // painter: CrossHairPaint(hover,width: context.size.width,height: context.size.height),
                                ),

                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<PhotoViewControllerValue>(
                          stream: _pContrl.outputStateStream,
                            initialData: PhotoViewControllerValue(
                              position: _pContrl.position,
                              rotation: 0,
                              rotationFocusPoint: null,
                              scale: _pContrl.scale,
                            ),
                          builder: (context, snapshot) {
                            gridIntersection(snapshot, c);
                            return
                              moving==false&&_offset==Offset.zero?Stack(
                                children: bb.map((e) {
                                    return Positioned.fromRect(
                                      rect: Rect.fromCenter(center: e.p, width: 50, height: 50),
                                      child: Transform.scale(
                                        scale: 1 / snapshot.data.scale,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: Container(
                                                color: Colors.redAccent,
                                                child: Center(
                                                    child: Text(
                                                  e.name.replaceAll('-', ''),
                                                  style: TextStyle(color: Colors.white),
                                                )))),
                                      ),
                                    );
                                  }).toList()):Container();
                          }
                        )
                        ///고정그리드 구현중
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
               color: Colors.white54,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 50,),
                    IconButton(
                      icon: Icon(CommunityMaterialIcons.search_web),
                      iconSize: 48,
                      tooltip: '검색',
                      onPressed: () {
                        Get.defaultDialog(title: '도면검색', content: SearchDialog(drawings));
                      },),
                    IconButton(
                      icon: Icon(CommunityMaterialIcons.star),
                      iconSize: 48,
                      tooltip: '즐겨찾기',
                      onPressed: () {
                        Get.defaultDialog(
                            title: '즐겨찾기',
                            content: Wrap(
                              children: context
                                  .read<Current>()
                                  .favorite
                                  .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      context.read<Current>().changePath(e);
                                    });
                                  },
                                  child: Chip(
                                    avatar: CircleAvatar(child: Text(e.drawingNum[0])),
                                    label: Text(e.title),
                                  ),
                                ),
                              ))
                                  .toList(),
                            ));
                      },),
                    Tooltip(
                      message: '도면검색',
                      child: InkWell(
                        onLongPress: () {
                          context.read<Current>().addFavorite(e);
                        },
                        onTap: () {
                          Get.defaultDialog(title: '도면검색', content: SearchDialog(drawings));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            context.read<Current>().getDrawing().toString(),
                            textScaleFactor: 2,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 72,
                        tooltip: '아래층',
                        onPressed: () {
                          Drawing c = context.read<Current>().getDrawing();
                          Current temp = context.read<Current>();
                          List<Drawing> tempcon = drawings
                              .where((e) =>
                          e.doc == c.doc &&
                              e.con == c.con &&
                              e.title.substring(e.title.length - 1) == c.title.substring(c.title.length - 1))
                              .toList();
                          temp.changePath(tempcon.elementAt((tempcon.indexOf(c) - 1)));
                        }),
                    IconButton(
                        icon: Icon(Icons.keyboard_arrow_up),
                        iconSize: 72,
                        tooltip: '위층',
                        onPressed: () {
                          Drawing c = context.read<Current>().getDrawing();
                          Current temp = context.read<Current>();
                          List<Drawing> tempcon = drawings
                              .where((e) =>
                          e.doc == c.doc &&
                              e.con == c.con &&
                              e.title.substring(e.title.length - 1) == c.title.substring(c.title.length - 1))
                              .toList();
                          temp.changePath(tempcon.elementAt((tempcon.indexOf(c) + 1)));
                        }),
                    IconButton(
                      icon: Icon(Icons.all_inbox_rounded),
                      iconSize: 48,
                      tooltip: '공정',
                      onPressed: () {
                          Drawing c = context.read<Current>().getDrawing();
                          Current temp = context.read<Current>();
                          List<Drawing> tempcon = drawings
                              .where((e) =>
                          e.doc == c.doc &&
                              e.con != c.con &&
                              e.floor == c.floor &&
                              e.title.substring(e.title.length - 1) == c.title.substring(c.title.length - 1))
                              .toList();
                          Get.defaultDialog(
                              title: '공정이동',
                              content: Column(
                                children: tempcon
                                    .map((e) => ListTile(
                                  title: Text(e.toString()),
                                  onTap: (){
                                    context.read<Current>().changePath(e);
                                    Navigator.pop(context);
                                  },
                                ))
                                    .toList(),
                              ));
                        },),
                    IconButton(
                      icon: Icon(CommunityMaterialIcons.ruler),
                      iconSize: 48,
                      tooltip: '측정',
                      onPressed: () {
                        setState(() {
                          taskAdd = !taskAdd;
                          boundarys = [];
                          tracking = [];
                          measurement = [];
                          rmeasurement = [];
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(CommunityMaterialIcons.filter_menu),
                      iconSize: 48,
                      tooltip: '필터',
                      onPressed: () {
                        setState(() {
                          callOutLayerOn = !callOutLayerOn;
                        });
                      },
                    ),
                    SizedBox(width: 50,),
                  ],
                ),
              ),
              SizedBox(height: 100,)
            ],
          ),
        ),

      ],
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

  Stack detailInfo(BuildContext context, BoxConstraints c) {
    return Stack(
      children: [
        Stack(
          children: drawings.singleWhere((d) => d.drawingNum == 'A31-109').detailInfoMap.map((e) {
            double tempX = e['x'] / (500 * 421.0) * c.maxWidth;
            double tempY = e['y'] / (500 * 297.0) * c.maxHeight;
            return Positioned(
                left: tempX + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dx,
                top: tempY + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dy,
                child: Text(
                  '${e['name']}',
                  textScaleFactor: 0.1,
                ));
          }).toList(),
        ),
        Stack(
          children: drawings.singleWhere((d) => d.drawingNum == 'A31-110').detailInfoMap.map((e) {
            double tempX = e['x'] / (500 * 421.0) * c.maxWidth;
            double tempY = e['y'] / (500 * 297.0) * c.maxHeight;
            return Positioned(
                left: tempX + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dx,
                top: tempY + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dy,
                child: Text(
                  '${e['name']}',
                  textScaleFactor: 0.1,
                ));
          }).toList(),
        ),
        Stack(
          children: drawings.singleWhere((d) => d.drawingNum == 'A31-111').detailInfoMap.map((e) {
            double tempX = e['x'] / (500 * 421.0) * c.maxWidth;
            double tempY = e['y'] / (500 * 297.0) * c.maxHeight;
            return Positioned(
                left: tempX + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dx,
                top: tempY + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dy,
                child: Text(
                  '${e['name']}',
                  textScaleFactor: 0.1,
                ));
          }).toList(),
        ),
        Stack(
          children: drawings.singleWhere((d) => d.drawingNum == 'A31-112').detailInfoMap.map((e) {
            double tempX = e['x'] / (500 * 421.0) * c.maxWidth;
            double tempY = e['y'] / (500 * 297.0) * c.maxHeight;
            return Positioned(
                left: tempX + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dx,
                top: tempY + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dy,
                child: Text(
                  '${e['name']}',
                  textScaleFactor: 0.1,
                ));
          }).toList(),
        ),
      ],
    );
  }

  Stack planInfo(BuildContext context, BoxConstraints c) {
    return Stack(
      children: context.watch<Current>().getDrawing().detailInfoMap.map((e) {
        double tempX = e['x'] / (double.parse(context.watch<Current>().getDrawing().scale) * 421.0) * c.maxWidth;
        double tempY = e['y'] / (double.parse(context.watch<Current>().getDrawing().scale) * 297.0) * c.maxHeight;
        return Positioned(
            left: tempX + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dx,
            top: tempY + context.watch<Current>().getcordiOffset(c.maxWidth, c.maxHeight).dy,
            child: Text(
              '${e['name']}',
              textScaleFactor: 0.2,
            ));
      }).toList(),
    );
  }

  void reaSelectIntersect(c) {
    double _scale = double.parse(context.read<Current>().getDrawing().scale) * 420.0;
    testgrids.where((e) => e.name == _gridX.text || e.name == _gridY.text).forEach((element) {
      print(element.name);
    });
    List<Gridtestmodel> selectGrid = testgrids.where((e) => e.name == _gridX.text || e.name == _gridY.text).toList();
    Line i = Line(Offset(selectGrid.first.startX.toDouble(), -selectGrid.first.startY.toDouble()),
        Offset(selectGrid.first.endX.toDouble(), -selectGrid.first.endY.toDouble()));
    Line j = Line(Offset(selectGrid.last.startX.toDouble(), -selectGrid.last.startY.toDouble()),
        Offset(selectGrid.last.endX.toDouble(), -selectGrid.last.endY.toDouble()));
    selectIntersect = Intersection().compute(i, j) / _scale * c.maxWidth;
    realIntersect = Intersection().compute(i, j);
  }

  void recaculate() {
    List<Line> lines = [];
    double _scale = double.parse(context.read<Current>().getDrawing().scale) * 420.0;
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
  List gridIntersection(snapshot, c){
    Offset cordi = context.read<Current>().getcordiOffset(c.maxWidth, c.maxHeight);
    double sS = snapshot.data.scale;
    double scale = double.parse(context.read<Current>().getDrawing().scale) * 420 / c.maxWidth;
    Rect b = Rect.fromCenter(
        center: Offset(c.maxWidth / 2 - keyX * c.maxWidth, c.maxHeight / 2 - keyY * c.maxHeight),
        width: c.maxWidth * 0.95 / sS,
        height: c.maxHeight * 0.92 / sS);
    Line aa = Line(b.topLeft, b.topRight);
    List<Line> ab = [
      Line(b.topLeft, b.topRight),
      Line(b.topRight, b.bottomRight),
      Line(b.bottomRight, b.bottomLeft),
      Line(b.bottomLeft, b.topLeft),
    ];
    List<Line> temp = [];
    bb = [];
    testgrids.forEach((e) {
      Line _line =Line(Offset(e.startX.toDouble(), -e.startY.toDouble()) / scale + cordi,
          Offset(e.endX.toDouble(), -e.endY.toDouble()) / scale + cordi);
      ab.forEach((l) {
        if(Intersection().checkCollision(_line, l) == false){
        } else {
          bb.add(GridIcon(Intersection().compute(_line, l), e.name));
        }
      });

      // temp.forEach((t) {
      //   if (Intersection().checkCollision(t, aa) == false) {
      //   } else {
      //     bb.add(GridIcon(Intersection().compute(t, aa), e.name));
      //   }
      // });
    });
    return bb;
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
class GridIcon{
  Offset p;
  String name;

  GridIcon(this.p, this.name);
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
      ..strokeWidth = 5.0 / s
      ..color = Color.fromRGBO(255, 0, 0, 1);
    Paint paint5 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0 / s
      ..style = PaintingStyle.fill
      ..color = Color.fromRGBO(255, 0, 0, 1);
    Paint paint6 = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0 / s
      ..style = PaintingStyle.fill
      ..color = Color.fromRGBO(255, 0, 0, 0.3);

    Path p = Path();
    p.moveTo(tP[0].dx, tP[0].dy);
    tP.forEach((e) {
      p.lineTo(e.dx, e.dy);
    });
    p.close();
    tP == [] ? null : canvas.drawPath(p, paint6);

    tP == [] ? null : canvas.drawPoints(PointMode.points, tP, paint4);
    tP == [] ? null : canvas.drawPoints(PointMode.polygon, tP, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
