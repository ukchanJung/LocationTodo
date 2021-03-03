import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:flutter_app_location_todo/simul_test.dart';
import 'package:flutter_app_location_todo/ui/backup.dart';
import 'package:flutter_app_location_todo/ui/calendar_page.dart';
import 'package:flutter_app_location_todo/ui/general_info_page.dart';
import 'package:flutter_app_location_todo/ui/gridbutton_page.dart';
import 'package:flutter_app_location_todo/ui/label_text_widget.dart';
import 'package:flutter_app_location_todo/ui/location_image_page.dart';
import 'package:flutter_app_location_todo/ui/map_page.dart';
import 'package:flutter_app_location_todo/ui/ocr_setting_page.dart';
import 'package:flutter_app_location_todo/ui/originViewer.dart';
import 'package:flutter_app_location_todo/ui/planner_page.dart';
import 'package:flutter_app_location_todo/ui/setting_page.dart';
import 'package:flutter_app_location_todo/ui/simulation_page.dart';
import 'package:flutter_app_location_todo/ui/timview_page.dart';
import 'package:flutter_app_location_todo/ui/todo_detail_page.dart';
import 'package:flutter_app_location_todo/ui/viewer_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LocationTodo extends StatefulWidget {
  @override
  _LocationTodoState createState() => _LocationTodoState();
}

class _LocationTodoState extends State<LocationTodo> {
  List<TaskData> tasks = [];
  TextEditingController _textEditingController = TextEditingController();
  String _searchText = '';
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yy.MM.dd.');
  DateFormat formatter2 = DateFormat('HH:mm:ss');
  List<bool> togleSelect = [true];

  @override
  void initState() {
    super.initState();
    context.read<CP>().changePath(
          Drawing(
            drawingNum: 'A31-003',
            title: '1층 평면도',
            scale: '500',
            localPath: 'A31-003.png',
            originX: 0.7373979439768359,
            originY: 0.23113260932198965,
            witdh: 421,
            height: 297,
          ),
        );
    setState(() {
      tasks = [
        TaskData(DateTime.now(), name: '메모1'),
        TaskData(DateTime.now(), name: '메모2'),
        TaskData(DateTime.now(), name: '메모3'),
        TaskData(DateTime.now(), name: '메모4'),
        TaskData(DateTime.now(), name: '메모5'),
        TaskData(DateTime.now(), name: '메모6'),
        TaskData(DateTime.now(), name: '메모7'),
        TaskData(DateTime.now(), name: '메모8'),
        TaskData(DateTime.now(), name: '메모9'),
        TaskData(DateTime.now(), name: '메모10'),
        TaskData(DateTime.now(), name: '메모11'),
        TaskData(DateTime.now(), name: '메모12'),
        TaskData(DateTime.now(), name: '메모13'),
        TaskData(DateTime.now(), name: '메모14'),
      ];
      for (int i = 0; i < tasks.length; i++) {
        tasks[i].x = Random().nextInt(400).toDouble();
        tasks[i].y = Random().nextInt(280).toDouble();
      }
    });
  }

  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(accountName: Text('정욱찬'), accountEmail: null),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('도면뷰어'),
                    onTap: () => Get.to(GridButton()),
                  ),
                  ListTile(
                    title: Text('공정관리'),
                    onTap: () => Get.to(SimulationPage()),
                  ),
                  ListTile(
                    title: Text('Setting'),
                    onTap: () => Get.to(SettingPage()),
                  ),
                  ListTile(
                    title: Text('Back Up'),
                    onTap: () => Get.to(BackupPage()),
                  ),
                  ListTile(
                    title: Text('시뮤레이션 테스트'),
                    onTap: () => Get.to(PlaySimul()),
                  ),
                  ListTile(
                    title: Text('상세도 OCR처리페이지'),
                    onTap: () => Get.to(OcrSettingPage()),
                  ),
                  ListTile(
                    title: Text('도면뷰어'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TimView()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('기존뷰어'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => originView()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('도면뷰어기능'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Viewer()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('도면문자처리'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dmap()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('공정표'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Planner()),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text('LTD Inbox ${tasks.where((e) => e.ischecked == false).length}/${tasks.length}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Calendar2()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {},
          ),
          Card(
            child: Container(
              width: 100,
              child: TextField(
                onChanged: (String value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(),
                  isDense: true,
                  labelText: 'Search',
                ),
              ),
            ),
          ),
        ],
      ),
      //리스트 초기화 임시버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            tasks = [];
          });
        },
      ),
      body: Column(
        children: [
          //위치 표현 이미지 위젯
          LocationImage(tasks),
          // AspectRatio 활용하여 이미지 사이즈 변경 기능 추가예정
          Divider(
            thickness: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildTodoAddUI(),
          ),
          //Task가 모두 처리됬을때 알려줌
          Expanded(
            child: Column(
              children: [
                tasks.where((element) => element.ischecked == false).length < 1
                    ? Expanded(
                        child: Center(
                            child: Text(
                        '할일이 없습니다',
                        textScaleFactor: 2,
                      )))
                    : buildTodoList(),
                Divider(
                  color: Colors.grey,
                ),
                ToggleButtons(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 144,
                        child: Center(
                          // 완료된 Task 숫자 표현
                          child: Text(
                            '펼처보기 Task ${tasks.where((e) => e.ischecked).length} 개',
                            textScaleFactor: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      togleSelect[index] = !togleSelect[index];
                    });
                  },
                  isSelected: togleSelect,
                ),
                togleSelect[0] == true ? Container() : buildDoneList(),
                SizedBox(
                  height: 24.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTodoList() {
    return Expanded(
      child: ListView(
        children: tasks.reversed
            // 검색시 띄어쓰기 및 소문자 대문자 무시
            .where((search) =>
                search.name.replaceAll(' ', '').toLowerCase().contains(_searchText.replaceAll(' ', '').toLowerCase()))
            .where((element) => element.ischecked == false)
            .map(
              (e) => Card(
                child: GestureDetector(
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TodoDetail(e)),
                    );
                    setState(() {
                      //메모 상세페이지
                    });
                    print('롱프레스');
                  },
                  child: CheckboxListTile(
                    //체크박스 타일 위치 바꾸기
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: IconButton(
                      //즐겨찾기 기능구현
                      onPressed: () {
                        setState(() {
                          e.favorite = !e.favorite;
                        });
                      },
                      //3항 연산을 활용한 즐겨찾기 아이콘 변경
                      icon: e.favorite == false
                          ? Icon(Icons.star_border)
                          : Icon(
                              Icons.star,
                              color: Colors.red,
                            ),
                    ),
                    title: Row(
                      children: [
                        Text(e.name),
                        //수정일 배치를 위한 위젯
                        Expanded(child: SizedBox()),
                        Column(
                          children: [
                            Text(
                              formatter.format(e.writeTime),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              formatter2.format(e.writeTime),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Text('${e.x},${e.y}'),
                    //체크박스 기능 구현
                    value: e.ischecked,
                    onChanged: (bool value) {
                      setState(() {
                        e.ischecked = value;
                      });
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildDoneList() {
    return Expanded(
      child: ListView(
        children: tasks.reversed
            // 검색시 띄어쓰기 및 소문자 대문자 무시
            .where((search) =>
                search.name.replaceAll(' ', '').toLowerCase().contains(_searchText.replaceAll(' ', '').toLowerCase()))
            .where((element) => element.ischecked == true)
            .map(
              (e) => Card(
                child: CheckboxListTile(
                  //체크박스 타일 위치 바꾸기
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: IconButton(
                    //즐겨찾기 기능구현
                    onPressed: () {
                      setState(() {
                        e.favorite = !e.favorite;
                      });
                    },
                    //3항 연산을 활용한 즐겨찾기 아이콘 변경
                    icon: e.favorite == false
                        ? Icon(Icons.star_border)
                        : Icon(
                            Icons.star,
                            color: Colors.red,
                          ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        e.name,
                        style: TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                      //수정일 배치를 위한 위젯
                      Expanded(child: SizedBox()),
                      Column(
                        children: [
                          Text(
                            formatter.format(e.writeTime),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            formatter2.format(e.writeTime),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //체크박스 기능 구현
                  value: e.ischecked,
                  onChanged: (bool value) {
                    setState(() {
                      e.ischecked = value;
                    });
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  //TODO추가 기능
  Widget buildTodoAddUI() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              labelText: 'GTD',
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        ElevatedButton(
          child: Text('등록'),
          onPressed: () {
            //메서드?를 UI에서분리해야될것 같음
            setState(() {
              var _wTime = DateTime.now();
              tasks.add(TaskData(_wTime, name: _textEditingController.text));
              // 등록 버튼 클릭시 필드 초기화
              _textEditingController.text = '';
            });
          },
        )
      ],
    );
  }
}
