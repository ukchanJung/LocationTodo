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
  CP tempList ;
  List<Drawing> tempcon ;
  DateTime day ;
  CarouselController _carouselController = CarouselController();
  ScrollController _gantContrl = ScrollController();
  List<DateTime> calendars = List.generate(100, (index) => DateTime.now().add(Duration(days: -7 + index)));
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
      setState(() {
       c = context.read<CP>().getDrawing();
      tempList = context.read<CP>();
      tempcon = drawings
          .where((e) =>
      e.doc == c.doc &&
          e.con == c.con &&
          e.title.substring(e.title.length - 1) == c.title.substring(c.title.length - 1))
          .toList();
      });
    });
    void readDrawing() async{
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('drawing').get();
      drawings = read.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      c = context.read<CP>().getDrawing();
      tempList = context.read<CP>();
      tempcon = drawings
          .where((e) =>
      e.doc == c.doc &&
          e.con == c.con &&
          e.title.substring(e.title.length - 1) == c.title.substring(c.title.length - 1))
          .toList();
    }
    // readDrawing();
    void readTasks() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('tasks').get();
      tasks2 = read.docs.map((e) => Task2.fromSnapshot(e)).toList();
      print(tasks2.where((e) =>e.floor==1 ).length);
      print(tasks2.where((e) =>e.floor==2 ).length);
    }

    readTasks();
    DateTime t=DateTime.now();
    day = DateTime.utc(t.year,t.month,t.day,9);
    print(day);
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
    tempcon!=null?temp = tempcon
        .map(
          (e) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateZ(0)
          // ..rotateX(ori?-0.4:0)
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
                                      context.watch<CP>().getDrawing().scale != '1'
                                      ? TaskBoundaryRead(
                                          tasks2: tasks2,
                                          width: width,
                                          height: height,
                                          pContrl: _pContrl,
                                          day: day,
                                        m: true,
                                        add: true,
                                        )
                                      : Container(),
                                      // context.watch<Current>().getDrawing().scale != '1'
                                      // ? TaskBoundaryRead2(
                                      //     tasks2: tasks2,
                                      //     width: width,
                                      //     height: height,
                                      //     pContrl: _pContrl,
                                      //     day: day,
                                      //   m: true,
                                      //   add: true,
                                      //   )
                                      // : Container(),
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
        .toList():null;
    return Scaffold(
      appBar: AppBar(
        title: Text('${DateFormat('yy.MM.dd').format(day)} ${context.watch<CP>().getDrawing().floor}층 작업사항'),
        actions: [
          IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            setState(() {
              print('왼쪽');
              // _carouselController.previousPage();
              day = day.subtract(Duration(days: 1));
            });
            setState(() {
            });
          }),
          IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: (){
            setState(() {
              print('오른쪽');
              // _carouselController.nextPage();
              day = day.add(Duration(days: 1));

            });
            setState(() {
            });
          }),
        ],
      ),
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (k){
          if(k.character=='d'){
            setState(() {
            print('왼쪽');
            _carouselController.nextPage();
          });
          }else if(k.character == "a"){
            print('오른쪽');
            setState(() {
              _carouselController.previousPage();
            });
          }
        },
        child: LayoutBuilder(
          builder: (context, bodySize) {
            return FutureBuilder(
                future: watch,
                builder: (context, snapshot) {
                  bool ori =MediaQuery.of(context).orientation == Orientation.landscape;
                  if(watch.isBlank) {return CircularProgressIndicator();}
                  return Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Card(
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                      enlargeStrategy: CenterPageEnlargeStrategy.scale,
                                      enlargeCenterPage: true,
                                      height:bodySize.maxHeight,
                                      // height: ori?bodySize.maxHeight:null,
                                      // aspectRatio: 420/297,
                                      // disableCenter: true,
                                      initialPage: 2,
                                      scrollDirection: Axis.vertical,
                                      onPageChanged: (index,k){
                                        print(k);
                                        setState(() {
                                          tempList.changePath(tempcon.elementAt(index));
                                        });
                                      }
                                    // autoPlay:true
                                  ),
                                  items: temp!=null?temp:[],
                                ),
                              ),
                            ),
                            Expanded(flex: 3,child: Card(child: buildTaskAddWidget(context))),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       ori?Container():Expanded(flex: 2,child: Card(child: buildTaskAddWidget(context))),
                      //       Expanded(
                      //         flex: 3,
                      //         child: Card(
                      //           child: CarouselSlider(
                      //             options: CarouselOptions(
                      //                 enlargeStrategy: CenterPageEnlargeStrategy.scale,
                      //                 enlargeCenterPage: true,
                      //                 height:bodySize.maxHeight,
                      //                 // height: ori?bodySize.maxHeight:null,
                      //                 // aspectRatio: 420/297,
                      //                 // disableCenter: true,
                      //                 initialPage: 2,
                      //                 scrollDirection: Axis.vertical,
                      //                 onPageChanged: (index,k){
                      //                   print(k);
                      //                   setState(() {
                      //                     tempList.changePath(tempcon.elementAt(index));
                      //                   });
                      //                 }
                      //               // autoPlay:true
                      //             ),
                      //             items: temp!=null?temp:[],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(flex:5,child: Card(child: Column(
                              children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${DateFormat('yy.MM.dd').format(day)}',textScaleFactor: 1.3,),
                                        ),
                                        Expanded(child: ListTile(title: Text('금일'),)),
                                      ],
                                    ),
                                Divider(),
                                Expanded(
                                  child: ListView(children: [
                                    ExpansionTile(initiallyExpanded: true,title: Text('작업 사항'),children: tasks2
                                        .where((t) =>
                                    day.isAfter(t.start.subtract(Duration(days: 1))) &&
                                        day.isBefore(t.end))
                                        .map((e) => ListTile(title: Text('작업'),trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(child: Text('완료'),onPressed: (){},),
                                            SizedBox(width: 8,),
                                            ElevatedButton(child: Text('미완료'),onPressed: (){},),
                                          ],
                                        ),))
                                        .toList(),),
                                    ExpansionTile(
                                      title: Text('인원 현황'),

                                    ),
                                    ExpansionTile(title: Text('인원 현황')),
                                    ExpansionTile(title: Text('장비 현황')),
                                    ExpansionTile(title: Text('자재 현황')),
                                    ExpansionTile(title: Text('특이사항')),
                                  ],),
                                ),
                              ],
                            ),)),
                            Expanded(flex:3,child: Card(child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${DateFormat('yy.MM.dd').format(day.add(Duration(days: 1)))}',textScaleFactor: 1.3,),
                                    ),
                                    Expanded(child: ListTile(title: Text('명일계획'),)),
                                  ],
                                ),
                                Divider(),
                                Expanded(
                                  child: ListView(children: [
                                    ExpansionTile(initiallyExpanded: true,title: Text('작업 사항'),children: tasks2
                                        .where((t) =>
                                    day.isAfter(t.start) &&
                                        day.isBefore(t.end.add(Duration(days: 1))))
                                        .map((e) => ListTile(title: Text('작업'),trailing: ElevatedButton(child: Text('첨부파일'),onPressed: (){},),))
                                        .toList(),),
                                              ExpansionTile(
                                                title: Text('인원 현황'),

                                              ),
                                              ExpansionTile(title: Text('장비 현황')),
                                    ExpansionTile(title: Text('자재 현황')),
                                    ExpansionTile(title: Text('특이사항')),
                                  ],),
                                ),
                              ],
                            ))),
                          ],
                        ),
                      ),
                      // ori?Container():Expanded(
                      //   flex: 2,
                      //   child: Row(
                      //     children: [
                      //       Expanded(flex:2,child: Card(child: Column(
                      //         children: [
                      //               Row(
                      //                 children: [
                      //                   Padding(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     child: Text('${DateFormat('yy.MM.dd').format(day)}',textScaleFactor: 1.3,),
                      //                   ),
                      //                   Expanded(child: ListTile(title: Text('금일'),)),
                      //                 ],
                      //               ),
                      //           Divider(),
                      //           Expanded(
                      //             child: ListView(children: [
                      //               ExpansionTile(initiallyExpanded: true,title: Text('작업 사항'),children: tasks2
                      //                   .where((t) =>
                      //               day.isAfter(t.start.subtract(Duration(days: 1))) &&
                      //                   day.isBefore(t.end))
                      //                   .map((e) => ListTile(title: Text('작업'),trailing: Row(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       ElevatedButton(child: Text('완료'),onPressed: (){},),
                      //                       SizedBox(width: 8,),
                      //                       ElevatedButton(child: Text('미완료'),onPressed: (){},),
                      //                     ],
                      //                   ),))
                      //                   .toList(),),
                      //               ExpansionTile(
                      //                 title: Text('인원 현황'),
                      //
                      //               ),
                      //               ExpansionTile(title: Text('인원 현황')),
                      //               ExpansionTile(title: Text('장비 현황')),
                      //               ExpansionTile(title: Text('자재 현황')),
                      //               ExpansionTile(title: Text('특이사항')),
                      //             ],),
                      //           ),
                      //         ],
                      //       ),)),
                      //       Expanded(flex:3,child: Card(child: Column(
                      //         children: [
                      //           Row(
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.all(8.0),
                      //                 child: Text('${DateFormat('yy.MM.dd').format(day.add(Duration(days: 1)))}',textScaleFactor: 1.3,),
                      //               ),
                      //               Expanded(child: ListTile(title: Text('명일계획'),)),
                      //             ],
                      //           ),
                      //           Divider(),
                      //           Expanded(
                      //             child: ListView(children: [
                      //               ExpansionTile(initiallyExpanded: true,title: Text('작업 사항'),children: tasks2
                      //                   .where((t) =>
                      //               day.isAfter(t.start) &&
                      //                   day.isBefore(t.end.add(Duration(days: 1))))
                      //                   .map((e) => ListTile(title: Text('작업'),trailing: ElevatedButton(child: Text('첨부파일'),onPressed: (){},),))
                      //                   .toList(),),
                      //                         ExpansionTile(
                      //                           title: Text('인원 현황'),
                      //
                      //                         ),
                      //                         ExpansionTile(title: Text('장비 현황')),
                      //               ExpansionTile(title: Text('자재 현황')),
                      //               ExpansionTile(title: Text('특이사항')),
                      //             ],),
                      //           ),
                      //         ],
                      //       ))),
                      //     ],
                      //   ),
                      // )
                    ],
                  );
                });
          }
        ),
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
              children: tasks2.where((t) => t.floor == context.watch<CP>().getDrawing().floor).map((e) {
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
                        onLongPress: (){
                          setState(() {
                            e.favorite = !e.favorite;
                          });
                        },
                        onTap: () {
                          setState(() {
                            print(day);
                            print(e.start);
                            day = e.start.add(Duration(seconds: 1));
                            // day = e.start;
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
                            color: e.start.subtract(Duration(days: 1)).isAfter(d) || e.end.isBefore(d)
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
    @required this.m,
    @required this.add,
  }) : _pContrl = pContrl, super(key: key);

  final List<Task2> tasks2;
  final double width;
  final double height;
  final DateTime day;
  final PhotoViewController _pContrl;
  final bool m;
  final bool add;

  @override
  _TaskBoundaryReadState createState() => _TaskBoundaryReadState();
}

class _TaskBoundaryReadState extends State<TaskBoundaryRead> {
  List<Task2> set ;
  @override
  void initState() {
    super.initState();
    setState(() {
    set =widget.tasks2;
    // .where((d) => d.start.isAfter(widget.day.add(Duration(days: -1)))&&d.end.isBefore(widget.day2))
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: set
            .where((d) {
              return widget.day.isAfter(d.start) && widget.day.isBefore(d.end.add(Duration(days: 1)));
            })
            .where((t) => t.floor == context.watch<CP>().getDrawing().floor).toList()
        .map((e) {
      var watch = context.watch<CP>();
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
            // if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            return Stack(
              children: [
                CustomPaint(
                  painter: TaskBoundaryPaint(tP: parse, s: snapshot.data.scale,select: e.favorite),
                ),
                widget.m&&widget.add
                    ?ClipPath(
                  clipper: TaskClip(parse),
                  child: Container(
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.deepOrange.withOpacity(0.5),
                        onLongPress: (){
                          setState(() {
                            e.favorite =!e.favorite;
                          });
                        },
                        onTap: (){
                          print('클릭');
                          print((widget.day.difference(e.start).inDays/e.end.difference(e.start).inDays));
                          Get.defaultDialog(
                              title: e.name,
                              content:  SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                          '${DateFormat('yy.MM.dd').format(e.start)} ~ ${DateFormat('yy.MM.dd').format(e.end)}'),
                                      subtitle: Text('공정 진행율 65.3%'),
                                    ),
                                    Stack(
                                      children: [
                                        Container(width:300,height:50,decoration: BoxDecoration(color:Colors.red),),
                                        Container(width:500,height:50,decoration: BoxDecoration(border: Border.all()),),
                                      ],
                                    ),
                                    ExpansionTile(subtitle: Text('총 42人'),title: Text('투입인원'),children: [
                                      ListTile(title: Text('21.02.16'),trailing: ElevatedButton(child: Text('9명'),onPressed:(){} ,),),
                                      ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text('추가하기')),
                                    ],),
                                    ExpansionTile(title: Text('장비 투입'),children: [
                                      ListTile(title: Text('21.02.16'),trailing: ElevatedButton(child: Text('3EA'),onPressed:(){} ,),),
                                      ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text('추가하기')),
                                    ],),
                                    Divider(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(title: Text('메모')),
                                        Container(decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide.none)),),
                                      ],
                                    ),
                                    ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.add_photo_alternate_rounded), label: Text('첨부 파일'))
                                  ],
                                ),
                              ));
                        },
                      ),
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    color: Colors.transparent,
                  ),
                ):Container(),
              ],
            );
          });
    }).toList());
  }
}
// class TaskBoundaryRead2 extends StatefulWidget {
//   const TaskBoundaryRead2({
//     Key key,
//     @required this.tasks2,
//     @required this.width,
//     @required this.height,
//     @required this.day,
//     @required PhotoViewController pContrl,
//     @required this.m,
//     @required this.add,
//   }) : _pContrl = pContrl, super(key: key);
//
//   final List<Task2> tasks2;
//   final double width;
//   final double height;
//   final DateTime day;
//   final PhotoViewController _pContrl;
//   final bool m;
//   final bool add;
//
//   @override
//   _TaskBoundaryRead2State createState() => _TaskBoundaryRead2State();
// }
//
// class _TaskBoundaryRead2State extends State<TaskBoundaryRead2> {
//   List<Task2> set ;
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//     set =widget.tasks2;
//     // .where((d) => d.start.isAfter(widget.day.add(Duration(days: -1)))&&d.end.isBefore(widget.day2))
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//     children: set
//             .where((d) {
//               return widget.day.isAfter(d.start) && widget.day.isBefore(d.end.add(Duration(days: 1)));
//             })
//             .where((t) => t.floor == context.watch<Current>().getDrawing().floor).toList()
//         .map((e) {
//       var watch = context.watch<Current>();
//       List<Offset> data = e.boundarys;
//       List<Offset> parse = data
//           .map((e) => Offset(
//           e.dx / (watch.getcordiX() / widget.width) + (watch.getDrawing().originX * widget.width),
//           e.dy / (watch.getcordiY() / widget.height) +
//               ((watch.getDrawing().originY * widget.height))))
//           .toList();
//       Path p = Path();
//       p.moveTo(parse[0].dx, parse[0].dy);
//       parse.forEach((e) {
//         p.lineTo(e.dx, e.dy);
//       });
//       p.close();
//
//
//       return StreamBuilder<PhotoViewControllerValue>(
//           stream: widget._pContrl.outputStateStream,
//           initialData: PhotoViewControllerValue(
//             position: widget._pContrl.position,
//             rotation: 0,
//             rotationFocusPoint: null,
//             scale: widget._pContrl.scale,
//           ),
//           builder: (context, snapshot) {
//             // if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//             return widget.m&&widget.add
//                 ?ClipPath(
//                   clipper: TaskClip(p),
//                   child: Container(
//             child: Material(
//               child: InkWell(
//                 splashColor: Colors.deepOrange.withOpacity(0.5),
//                 onLongPress: (){
//                   setState(() {
//                     e.favorite =!e.favorite;
//                   });
//                 },
//                 onTap: (){
//                   print('클릭');
//                   print((widget.day.difference(e.start).inDays/e.end.difference(e.start).inDays));
//                         Get.defaultDialog(
//                             title: e.name,
//                             content:  SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ListTile(
//                                     title: Text(
//                                         '${DateFormat('yy.MM.dd').format(e.start)} ~ ${DateFormat('yy.MM.dd').format(e.end)}'),
//                                     subtitle: Text('공정 진행율 65.3%'),
//                                   ),
//                                   Stack(
//                                     children: [
//                                       Container(width:300,height:50,decoration: BoxDecoration(color:Colors.red),),
//                                       Container(width:500,height:50,decoration: BoxDecoration(border: Border.all()),),
//                                     ],
//                                   ),
//                                   ExpansionTile(subtitle: Text('총 42人'),title: Text('투입인원'),children: [
//                                     ListTile(title: Text('21.02.16'),trailing: ElevatedButton(child: Text('9명'),onPressed:(){} ,),),
//                                     ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text('추가하기')),
//                                   ],),
//                                   ExpansionTile(title: Text('장비 투입'),children: [
//                                     ListTile(title: Text('21.02.16'),trailing: ElevatedButton(child: Text('3EA'),onPressed:(){} ,),),
//                                     ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text('추가하기')),
//                                   ],),
//                                   Divider(),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       ListTile(title: Text('메모')),
//                                       Container(decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide.none)),),
//                                     ],
//                                   ),
//                                   ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.add_photo_alternate_rounded), label: Text('첨부 파일'))
//                                 ],
//                               ),
//                             ));
//                       },
//               ),
//               color: Colors.blue.withOpacity(0.2),
//             ),
//             color: Colors.transparent,
//                   ),
//                 ):Container();
//           });
//     }).toList());
//   }
// }
//
// class TaskRead extends StatefulWidget {
//   const TaskRead({
//     Key key,
//     @required this.tasks2,
//     @required this.width,
//     @required this.height,
//     @required this.day,
//     @required this.day2,
//     @required PhotoViewController pContrl,
//   }) : _pContrl = pContrl, super(key: key);
//
//   final List<Task2> tasks2;
//   final double width;
//   final double height;
//   final DateTime day;
//   final DateTime day2;
//   final PhotoViewController _pContrl;
//
//   @override
//   _TaskReadState createState() => _TaskReadState();
// }
//
// class _TaskReadState extends State<TaskRead> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//         children: widget.tasks2
//             // .where((d) => !(d.start.isBefore(widget.day)||!widget.day2.isBefore(d.end) ))
//             // .where((d) => !d.start.isBefore(widget.day)||!d.end.isBefore(widget.day2) )
//             // .where((d) => d.start.isBefore(widget.day)||d.end.isAfter(widget.day2))
//         // .where((d) => d.start.isAfter(widget.day.add(Duration(days: -1)))&&d.end.isBefore(widget.day2))
//             .where((t) => t.floor == context.watch<Current>().getDrawing().floor)
//             .map((e) {
//           var watch = context.watch<Current>();
//           List<Offset> data = e.boundarys;
//           List<Offset> parse = data
//               .map((e) => Offset(
//               e.dx / (watch.getcordiX() / widget.width) + (watch.getDrawing().originX * widget.width),
//               e.dy / (watch.getcordiY() / widget.height) +
//                   ((watch.getDrawing().originY * widget.height))))
//               .toList();
//           return StreamBuilder<PhotoViewControllerValue>(
//               stream: widget._pContrl.outputStateStream,
//               initialData: PhotoViewControllerValue(
//                 position: widget._pContrl.position,
//                 rotation: 0,
//                 rotationFocusPoint: null,
//                 scale: widget._pContrl.scale,
//               ),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//                 return Stack(
//                   children: [
//                     CustomPaint(
//                       painter: TaskBoundaryPaint(tP: parse, s: snapshot.data.scale,select: e.favorite),
//                     ),
//                     ClipPath(
//                       clipper: TaskClip(parse),
//                       child: Container(
//                         child: Material(
//                           child: InkWell(
//                             splashColor: Colors.deepOrange.withOpacity(0.5),
//                             onTap: (){
//                               setState(() {
//                                 e.favorite =!e.favorite;
//                               });
//                             },
//                             onLongPress: (){
//                               print('클릭');
//                               Get.defaultDialog(title: e.name);
//                             },
//                           ),
//                           color: Colors.transparent,
//                         ),
//                         color: Colors.transparent,
//                       ),
//                     ),
//                   ],
//                 );
//               });
//         }).toList());
//   }
// }
