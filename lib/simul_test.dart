import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/ui/gridbutton_page.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class PlaySimul extends StatefulWidget {
  @override
  _PlaySimulState createState() => _PlaySimulState();
}

class _PlaySimulState extends State<PlaySimul> {
  List<Drawing> drawings = [];
  Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
  List<Widget> temp;
  double dWidth ;
  double dHeight ;
  PhotoViewController _pContrl = PhotoViewController();
  List<Task2> tasks2 = [];
  Drawing c ;
  Current tempList ;
  List<Drawing> tempcon ;
  DateTime day ;
  CarouselController _carouselController = CarouselController();
  ScrollController _gantContrl = ScrollController();
  List<DateTime> calendars = List.generate(21, (index) => DateTime.now().add(Duration(days: -7 + index)));
  DateFormat weekfomat = DateFormat.E();
  DateFormat mdformat = DateFormat('MM.dd');
  ScrollController gantControl = ScrollController();

  @override
  void initState() {
    super.initState();
    _gantContrl.addListener(() {
      gantControl.jumpTo(_gantContrl.offset);
    });

    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
       c = context.read<Current>().getDrawing();
      tempList = context.read<Current>();
      tempcon = drawings
          .where((e) =>
      e.doc == c.doc &&
          e.con == c.con &&
          e.title.substring(e.title.length - 1) == c.title.substring(c.title.length - 1))
          .toList();
    });
    void readTasks() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('tasks').get();
      tasks2 = read.docs.map((e) => Task2.fromSnapshot(e)).toList();
      tasks2.forEach((e) {print(e.toString());});
    }

    readTasks();
    day = DateTime.now();
  }
  @override
  void dispose() {
    super.dispose();
    _pContrl.dispose();
    _gantContrl.dispose();
    gantControl.dispose();

  }

  @override
  Widget build(BuildContext context) {
    bool ori =MediaQuery.of(context).orientation == Orientation.landscape;
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    double longestSide = MediaQuery.of(context).size.longestSide;
     dWidth = MediaQuery.of(context).size.width;
     dHeight = MediaQuery.of(context).size.height;
     bool left = false;
     bool right = false;
    temp = tempcon
        .map(
          (e) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateZ(0)
          ..rotateX(ori?-0.4:0)
          ..rotateY(0),
        origin: Offset(dWidth/2, dHeight*0.5),
        child: Container(
          child: Listener(
            onPointerMove: (m){
              if(m.delta.dx>0){
                left = true;
                right = false;
              }else if (m.delta.dx<0){
                left = false;
                right = true;
              }
            },
            child: CarouselSlider(
              carouselController: _carouselController,
                options: CarouselOptions(
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  enlargeCenterPage: true,
                  // aspectRatio: 420/297,
                  // disableCenter: true,
                  initialPage: 0,
                  onPageChanged:(index,C){
                    print(index);
                    print('left $left / right $right');
                        print(day.day);
                        setState(() {
                        if (left) {
                          print('이전 ${day.day}');
                          day = day.add(Duration(days: -1));
                          print('이후 ${day.day}');
                          print(day.day);
                          print('left s');
                        } else if (right) {
                          print('이전 ${day.day}');
                          day = day.add(Duration(days: 1));
                          print('이후 ${day.day}');
                          print('right s');
                        }

                        });
                      },
                  // autoPlay:true
                ),
                items:[
                  AspectRatio(
                    aspectRatio: 420/297,
                    child: ClipRect(
                        child: LayoutBuilder(
                            builder: (context, C) {
                              double width = C.maxWidth;
                              double height = C.maxWidth/(420/297);
                              return PhotoView.customChild(
                                  controller: _pContrl,
                                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                  child: Stack(
                                    children: [
                                      Image.asset('asset/photos/${e.localPath}'),
                                      context.watch<Current>().getDrawing().scale != '1'
                                      ? TaskBoundaryRead(
                                          tasks2: tasks2,
                                          width: width,
                                          height: height,
                                          pContrl: _pContrl,
                                          day: day,
                                        )
                                      : Container(),
                                    ],
                                  ));
                            }
                        )),
                  ),
                ] ,
        ),
          ),
      ),
    ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('4D시뮬레이션 테스트${day.day}'),
      ),
      body: LayoutBuilder(
        builder: (context, bodySize) {
          return FutureBuilder(
              future: watch,
              builder: (context, snapshot) {
                bool ori =MediaQuery.of(context).orientation == Orientation.landscape;
                return Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        enlargeCenterPage: true,
                        height: ori?bodySize.maxHeight:null,
                        // aspectRatio: 420/297,
                        // disableCenter: true,
                        initialPage: 2,
                        scrollDirection: Axis.vertical,
                        onPageChanged: (index,CarouselPageChangedReason){
                          print(index);
                          setState(() {
                          tempList.changePath(tempcon.elementAt(index));
                          });
                        }
                        // autoPlay:true
                      ),
                      items: temp,
                    ),
                    ori?Container():Expanded(child: buildTaskAddWidget(context))
                  ],
                );
              });
        }
      ),
    );
  }

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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: day.day == e.day ? Colors.orange : Colors.transparent,
                    ),
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
              children: tasks2.where((t) => t.floor == context.watch<Current>().getDrawing().floor).map((e) {
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
                            e.favorite = !e.favorite;
                            day = e.start;
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

}

class TaskBoundaryRead extends StatefulWidget {
  const TaskBoundaryRead({
    Key key,
    @required this.tasks2,
    @required this.width,
    @required this.height,
    @required this.day,
    @required PhotoViewController pContrl,
  }) : _pContrl = pContrl, super(key: key);

  final List<Task2> tasks2;
  final double width;
  final double height;
  final DateTime day;
  final PhotoViewController _pContrl;

  @override
  _TaskBoundaryReadState createState() => _TaskBoundaryReadState();
}

class _TaskBoundaryReadState extends State<TaskBoundaryRead> {

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: widget.tasks2
        .where((d) => widget.day.add(Duration(days: 1)).isAfter(d.start)&&widget.day.isBefore(d.end))
        // .where((d) => d.start.isAfter(widget.day.add(Duration(days: -1)))&&d.end.isBefore(widget.day2))
        .where((t) => t.floor == context.watch<Current>().getDrawing().floor)
        .map((e) {
      var watch = context.watch<Current>();
      List<Offset> data = e.boundarys;
      List<Offset> parse = data
          .map((e) => Offset(
          e.dx / (watch.getcordiX() / widget.width) + (watch.getDrawing().originX * widget.width),
          e.dy / (watch.getcordiY() / widget.height) +
              ((watch.getDrawing().originY * widget.height))))
          .toList();
      return StreamBuilder<PhotoViewControllerValue>(
          stream: widget._pContrl.outputStateStream,
          initialData: PhotoViewControllerValue(
            position: widget._pContrl.position,
            rotation: 0,
            rotationFocusPoint: null,
            scale: widget._pContrl.scale,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            return Stack(
              children: [
                CustomPaint(
                  painter: TaskBoundaryPaint(tP: parse, s: snapshot.data.scale,select: e.favorite),
                ),
                    ClipPath(
                  clipper: TaskClip(parse),
                  child: Container(
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.deepOrange.withOpacity(0.5),
                        onTap: (){
                          setState(() {
                            e.favorite =!e.favorite;
                          });
                        },
                        onLongPress: (){
                          print('클릭');
                          Get.defaultDialog(title: e.name);
                        },
                      ),
                      color: Colors.transparent,
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ],
            );
          });
    }).toList());
  }
}
