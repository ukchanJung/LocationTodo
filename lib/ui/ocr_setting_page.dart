// import 'dart:io';
// import 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_location_todo/data/lhchecklistdoc.dart';
import 'package:flutter_app_location_todo/data/lhchecklisttest.dart';
import 'package:flutter_app_location_todo/data/quailty_data.dart';
import 'package:flutter_app_location_todo/model/checklist_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show Codec, FrameInfo, Image;
import 'package:get/get.dart';

class OcrSettingPage extends StatefulWidget {
  @override
  _OcrSettingPageState createState() => _OcrSettingPageState();
}

class _OcrSettingPageState extends State<OcrSettingPage> {
  int index = 0;
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> data2 = [];
  Iterable temp;
  String temp2;
  Future<ui.Image> decodeImage;
  double iS;
  GlobalKey _keyA = GlobalKey();
  String selectT = '';
  bool isLoad = false;
  String selectText = '';
  String level1 = 'level 1 text';
  String level2 = 'level 2 text';
  String level3 = 'level 3 text';
  String level4 = 'level 4 text';
  String level5 = 'level 5 text';
  List<Map> listLevel = [];
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  List<CheckList> checkLists;
  List<String> f1;
  CheckList selectCheck;
  CheckType _checkType = CheckType.site;
  Map emptyField = {'name': 'name', '1': '1', '2': '2', '3': '3', '4': '4', '5': '5', '6': '6', '7': '7'};
  List<String> category1 = ['토목공사', '건축분야', '기계분야', '전기분야', '통신분야', '조경분야'];
  List<String> category2 = [];

  @override
  void initState() {
    super.initState();
    checkLists = qualityCheckList.map((e) => CheckList.fromMap(e)).toList();
    void read() async {
      QuerySnapshot read = await FirebaseFirestore.instance.collection('lhchecklist').get();
      data = read.docs.map((e) => e).toList();
      setState(() {});
    }

    checkLists = qualityCheckList.map((e) => CheckList.fromMap(e)).toList();
    void read2() async {
      QuerySnapshot read = await FirebaseFirestore.instance.collection('lhCheckListDocFin').get();
      data2 = read.docs.map((e) => e).toList();
      setState(() {});
    }

    f1 = checkLists.map((e) => e.type1).toSet().toList();
    selectCheck = checkLists.first;

    read();
    read2();
    // category2 = data2.map((e) => e.data().).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _textEditingController1.dispose();
    _textEditingController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("lhCheckListDocFin").snapshots(),
            builder: (context, snapshot) {
              snapshot.data.docs.forEach((element) {
                print(element.data()['timing']);
              });
              if (!snapshot.hasData) return LinearProgressIndicator();
              // return Container();
              List<QueryDocumentSnapshot> _d = snapshot.data.docs;
              print(_d.length);
              return ListView(
                children: snapshot.data.docs.map((e) {
                  // Map v = e.data();
                  // String t = v['type1'];
                  // CheckList _c = CheckList.fromMap(e.data());
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text('1'),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      appBar: AppBar(
        title: InkWell(
          child: Text('[$index/${data.length}]'),
          onTap: () {
            int goTo = index;
            Get.defaultDialog(
              title: '이동',
              content: Container(
                width: 400,
                height: 400,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (t) {
                          setState(() {
                            goTo = int.parse(t);
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            index = goTo;
                            setState(() {
                              isLoad = false;
                              // String tempRoot = 'asset/lhchecklist/${lhCheckListDocData[index]}.png';
                              // ByteData bytes = await rootBundle.load(tempRoot);
                              // String tempPath = (await getTemporaryDirectory()).path;
                              // String tempName = '$tempPath/${lhCheckListDocData[index]}.png';

                              // File file = File(tempName);
                              // await file
                              //     .writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                              // decodeImage = decodeImageFromList(file.readAsBytesSync());
                              // decodeImage.then((value) {
                              //   iS = 925 / _keyA.currentContext.size.width;
                              //   decodeImage.whenComplete(() {
                              //     isLoad = true;
                              //     setState(() {});
                              //   });
                              // });
                              iS = 925 / _keyA.currentContext.size.width;
                              isLoad = true;
                              print(data[index].data()['dataList']);
                              temp = data[index].data()['dataList'];
                              selectCheck..index = index;
                              Get.back();
                            });
                          });
                        },
                        child: Text('반영'))
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                listLevel = [];
              });
            },
            child: Text('리스트초기화'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isLoad = false;
                index--;
                selectCheck..index = index;
                iS = 925 / _keyA.currentContext.size.width;
                isLoad = true;
                print(data[index].data()['dataList']);
                temp = data[index].data()['dataList'];
                temp2 = data[index].data()['fulltext'];
              });
            },
            child: Text('이전'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isLoad = false;
                index++;
                selectCheck..index = index;
                iS = 925 / _keyA.currentContext.size.width;
                isLoad = true;
                print(data[index].data()['dataList']);
                temp = data[index].data()['dataList'];
              });
            },
            child: Text('다음'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectCheck..checkListDetail = listLevel;
                FirebaseFirestore.instance
                    .collection('lhCheckListDocFin')
                    .doc(selectCheck.toString())
                    .set(selectCheck.toMap());
                listLevel = [];
              });
            },
            child: Text('등록'),
          ),
        ],
      ),
      // floatingActionButton: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     FloatingActionButton(
      //       child: Text('+'),
      //       heroTag: null,
      //       onPressed: () {
      //         setState(() {
      //           isLoad = false;
      //           index++;
      //           selectCheck..index = index;
      //           iS = 925 / _keyA.currentContext.size.width;
      //           isLoad = true;
      //           print(data[index].data()['dataList']);
      //           temp = data[index].data()['dataList'];
      //         });
      //       },
      //     ),
      //     SizedBox(
      //       width: 24,
      //     ),
      //     FloatingActionButton(
      //       child: Text('-'),
      //       heroTag: null,
      //       onPressed: () {
      //         setState(() {
      //           isLoad = false;
      //           index--;
      //           selectCheck..index = index;
      //           iS = 925 / _keyA.currentContext.size.width;
      //           isLoad = true;
      //           print(data[index].data()['dataList']);
      //           temp = data[index].data()['dataList'];
      //           temp2 = data[index].data()['fulltext'];
      //         });
      //       },
      //     ),
      //     SizedBox(
      //       width: 24,
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {
      //         setState(() {
      //           listLevel = [];
      //         });
      //       },
      //       heroTag: null,
      //       child: Icon(Icons.refresh),
      //     ),
      //     SizedBox(
      //       width: 24,
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {
      //         setState(() {
      //           selectCheck..checkListDetail = listLevel;
      //           FirebaseFirestore.instance
      //               .collection('lhCheckListDocFin')
      //               .doc(selectCheck.toString())
      //               .set(selectCheck.toMap());
      //           listLevel = [];
      //         });
      //       },
      //       child: Text('등록'),
      //     ),
      //   ],
      // ),
      body: Row(
        children: [
          Container(
            width: 500,
            child: ListView(
              children: category1.map(
                (e) {
                  List l1 = data2
                      .where((v) => v.data()['type1'] == e)
                      .map((v) => v.data()['type2'])
                      .toList()
                      .toSet()
                      .toList();
                  return Card(
                    child: ExpansionTile(
                      title: Text(e),
                      children: l1.map((e) {
                        List<QueryDocumentSnapshot> l2 = data2.where((v) => v.data()['type2'] == e).toList();
                        return Card(
                          child: ExpansionTile(
                            title: Text(e),
                            children: l2.map((e) {
                              List l3 = e.data()['checkListDetail'];
                              return Card(
                                child: ExpansionTile(
                                  title: Text(e.data()['timing']),
                                  children: l3.map((e) {
                                    String i = e['index'].toString();
                                    List<String > indexParse =[];
                                    if(e['index']!=null){
                                    List indexData =  e['index'];
                                       indexParse = indexData.map((e) {
                                         String t = e['name'];
                                        if(e['2']!=null)t=t+ '_'+e['2']+'.';
                                        if(e['3']!=null)t=t+ e['3']+'.';
                                        if(e['4']!=null)t=t+ e['4']+'.';
                                        if(e['6']!=null)t=t+ e['6']+'.';
                                        if(e['7']!=null)t=t+ e['7']+')';
                                        // t = '${e['name']}_${e['2']}.${e['3']}.${e['4']}_${e['6']}_${e['7']}';
                                        return t;
                                      }).toList();
                                    }
                                    return ListTile(
                                      title: Text(e['level1']),
                                      subtitle: Text(indexParse.toString()),
                                    );
                                  }).toList(),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          Container(
            width: 500,
            child: ListView(
              children: Atest(checkTestList),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  'asset/lhchecklist/${lhCheckListDocData[index]}.png',
                  key: _keyA,
                  fit: BoxFit.fill,
                ),
                temp != null && isLoad
                    ? RawKeyboardListener(
                        focusNode: FocusNode(),
                        autofocus: true,
                        onKey: (key) {
                          setState(() {
                            if (key.character == '3' && key.data.isAltPressed) {
                              Map temp = {'level1': selectText};
                              listLevel.add(temp);
                            }
                            if (key.character == '1' && key.data.isAltPressed) {
                              selectCheck.type2 = selectText;
                            }
                            if (key.character == '2' && key.data.isAltPressed) {
                              selectCheck.timing = selectText;
                            }
                          });
                        },
                        child: Stack(
                          children: temp
                              .map((e) => Positioned.fromRect(
                                  rect: Rect.fromLTRB(e['rect']['left'] / iS, e['rect']['top'] / iS,
                                      e['rect']['right'] / iS, e['rect']['bottom'] / iS),
                                  child: InkWell(
                                    onHover: (h) {
                                      setState(() {
                                        if (h) {
                                          selectText = e['text'].replaceAll("\n", " ");
                                          print(selectText.replaceAll("\n", "+"));
                                        }
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        selectT = e['text'];
                                      });
                                    },
                                    child: Tooltip(
                                      message: e['text'],
                                      child: Container(
                                        color: Color.fromRGBO(255, 0, 0, 0.15),
                                      ),
                                    ),
                                  )))
                              .toList(),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          // Container(
          //   width: 300,
          //   child: Scrollbar(
          //     child: ListView(
          //       children: f1.map((a) {
          //         return ExpansionTile(
          //           title: Text(a),
          //           children: checkLists.where((e) => e.type1 == a).map((e) => e.type2).toSet().map((b) {
          //             List<CheckList> f2 = checkLists.where((e) => e.type2 == b).toList();
          //             return ExpansionTile(
          //               title: Text(b),
          //               children: f2
          //                   .map((e) =>
          //                   ListTile(
          //                     title: Text(e.timing),
          //                     subtitle: Text(e.checkList),
          //                     onTap: () {
          //                       setState(() {
          //                         selectCheck =e;
          //                       });
          //                     },
          //                   ))
          //                   .toList(),
          //             );
          //           }).toList(),
          //         );
          //       }).toList(),
          //     ),
          //   )
          // ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Card(
                      child: ListTile(
                    leading: Text('공사명'),
                    title: AutoSizeText(selectCheck.type1, maxLines: 1),
                    onTap: () {
                      Get.defaultDialog(
                        title: '분야선택',
                        actions: [
                          ElevatedButton(onPressed: Get.back, child: Text('확인')),
                          ElevatedButton(onPressed: Get.back, child: Text('취소')),
                        ],
                        content: Container(
                          width: 300,
                          child: Column(
                            children: [
                              buildCheckTypeTile(CheckType.site, '토목분야'),
                              buildCheckTypeTile(CheckType.architecture, '건축분야'),
                              buildCheckTypeTile(CheckType.mec, '기계분야'),
                              buildCheckTypeTile(CheckType.elc, '전기분야'),
                              buildCheckTypeTile(CheckType.internet, '통신분야'),
                              buildCheckTypeTile(CheckType.landscape, '조경분야'),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _textEditingController1.text = selectCheck.type2;
                          Get.defaultDialog(
                            title: '수정',
                            content: TextField(
                              controller: _textEditingController1,
                              maxLines: 2,
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectCheck.type2 = _textEditingController1.text;
                                      Get.back();
                                    });
                                  },
                                  child: Text('수정')),
                              ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('취소')),
                            ],
                          );
                        });
                      },
                      child: Card(
                          child: ListTile(leading: Text('공종'), title: AutoSizeText(selectCheck.type2, maxLines: 1)))),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _textEditingController2.text = selectCheck.timing;
                          Get.defaultDialog(
                            title: '수정',
                            content: TextField(
                              controller: _textEditingController2,
                              maxLines: 2,
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectCheck.timing = _textEditingController2.text;
                                      Get.back();
                                    });
                                  },
                                  child: Text('수정')),
                              ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('취소')),
                            ],
                          );
                        });
                      },
                      child: Card(
                          child:
                              ListTile(leading: Text('세부공종'), title: AutoSizeText(selectCheck.timing, maxLines: 1)))),
                  Expanded(
                    child: Card(
                      color: Colors.white54,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Scrollbar(
                          isAlwaysShown: true,
                          thickness: 20,
                          child: ListView(
                            cacheExtent: 3000,
                            children: listLevel.map(
                              (e) {
                                List<Map> temp = e['index'];
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        _textEditingController.text = e['level1'];
                                        Get.defaultDialog(
                                          title: '수정',
                                          content: TextField(
                                            controller: _textEditingController,
                                            maxLines: 20,
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    e['level1'] = _textEditingController.text;
                                                    Get.back();
                                                  });
                                                },
                                                child: Text('수정')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text('취소')),
                                          ],
                                        );
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        listLevel.remove(e);
                                      });
                                    },
                                    leading: Text((listLevel.indexOf(e) + 1).toString()),
                                    subtitle: temp != null
                                        ? Column(
                                            children: temp
                                                .map((a) => InkWell(
                                                      onLongPress: () {
                                                        setState(() {
                                                          temp.remove(a);
                                                        });
                                                      },
                                                      child: Card(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Row(
                                                            children: [
                                                              buildIndexField('파일명', width: 100, onChanged: (t) {
                                                                a.update('name', (value) => t);
                                                                listLevel[listLevel.indexOf(e)] = e;
                                                              }),
                                                              buildIndexField('1.', onChanged: (t) {
                                                                a.update('2', (value) => t);
                                                                listLevel[listLevel.indexOf(e)] = e;
                                                              }),
                                                              buildIndexField('1.1', onChanged: (t) {
                                                                a.update('3', (value) => t);
                                                                listLevel[listLevel.indexOf(e)] = e;
                                                              }),
                                                              buildIndexField('1.1.1', onChanged: (t) {
                                                                a.update('4', (value) => t);
                                                                listLevel[listLevel.indexOf(e)] = e;
                                                              }),
                                                              buildIndexField('가.', onChanged: (t) {
                                                                a.update('6', (value) => t);
                                                                listLevel[listLevel.indexOf(e)] = e;
                                                              }),
                                                              buildIndexField('1)', onChanged: (t) {
                                                                a.update('7', (value) => t);
                                                                listLevel[listLevel.indexOf(e)] = e;
                                                              }),
                                                              buildIndexField('가)', onChanged: (t) {
                                                                a.update('8', (value) => t);
                                                                listLevel[listLevel.indexOf(e)] = e;
                                                              }),
                                                              buildIndexField('(1)', onChanged: (t) {
                                                                a.update('9', (value) => t);
                                                                listLevel[listLevel.indexOf(e)] = e;
                                                              }),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          )
                                        : Container(),
                                    title: Text(e['level1']),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Map t = emptyField;
                                              if (!e.containsKey('index')) {
                                                e.addAll({
                                                  'index': [
                                                    {
                                                      'name': 'name',
                                                      '1': null,
                                                      '2': null,
                                                      '3': null,
                                                      '4': null,
                                                      '5': null,
                                                      '6': null,
                                                      '7': null
                                                    },
                                                  ]
                                                });
                                              } else {
                                                e['index'].add(
                                                  {
                                                    'name': 'name',
                                                    '1': null,
                                                    '2': null,
                                                    '3': null,
                                                    '4': null,
                                                    '5': null,
                                                    '6': null,
                                                    '7': null
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          child: Text('추가'),
                                        )
                                      ],
                                    ),
                                    // subtitle: AutoSizeText(e['level2'], maxLines: 1),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildIndexField(String label, {Function(String) onChanged, double width = 65}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        width: width,
        child: TextField(
          decoration: InputDecoration(border: OutlineInputBorder(), labelText: label),
          onChanged: onChanged,
        ),
      ),
    );
  }

  RadioListTile<CheckType> buildCheckTypeTile(CheckType type, String value) {
    return RadioListTile(
      value: type,
      groupValue: _checkType,
      onChanged: (v) {
        setState(() {
          _checkType = v;
          selectCheck.type1 = value;
        });
      },
      title: Text(value),
    );
  }
}

enum CheckType { site, architecture, mec, elc, internet, landscape }

class LHMultiLevelList {
  int type;
  int index;
  String title;
  int level;
  String text;
  int i2 = 0;
  int i3 = 0;
  int i4 = 0;
  int i6 = 0;
  int i7 = 0;
  int i8 = 0;
  int i9 = 0;
  int i10 = 0;

  LHMultiLevelList(this.type, this.index, this.title, this.level, this.text);

  @override
  String toString() {
    return 'LHMultiLevelList{type: $type, level: $level, text: $text}';
  }

  String toCode() {
    return '$i2$i3$i4$i6$i7$i8$i9$i10';
  }

  LHMultiLevelList.fromMap(Map data) {
    type = data['type'];
    index = data['index'];
    title = data['title'];
    level = data['level'];
    text = data['text'];
  }
}

List<Widget> Atest(List data) {
  List<LHMultiLevelList> _list = data.map((e) => LHMultiLevelList.fromMap(e)).toList();
  List _type = _list.map((e) => e.type).toSet().toList();
  List<Widget> _widgets = _type.map(
    (e) {
      int _i = 0;
      List<LHMultiLevelList> l1 = _list.where((t1) => t1.type == e && t1.level == 2).toList();
      return Card(
        child: ExpansionTile(
          title: Text(
            e.toString(),
            maxLines: 1,
          ),
          children: l1.map(
            (e1) {
              _i++;
              int _i1 = 0;
              int a = l1.indexOf(e1);
              int s;
              int e;
              if (l1.last != e1) {
                s = l1[a].index;
                e = l1[a + 1].index;
              } else if (l1.last == e1) {
                s = l1[a].index;
                List<LHMultiLevelList> temp = _list.where((e) => e.index > s).toList();
                if (temp.where((e) => e.level == 2).toList().length != 0) {
                  e = _list.where((e) => e.index > s).firstWhere((e) => e.level == 2).index;
                } else {
                  e = _list.last.index;
                }
              }
              List<LHMultiLevelList> l2 = _list.sublist(s, e).where((t2) => t2.level == 3).toList();
              return Card(
                child: ExpansionTile(
                  leading: Text('A$_i'),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      e1.text,
                      maxLines: 1,
                    ),
                  ),
                  children: l2.map((e2) {
                    _i1++;
                    int _i2 = 0;
                    int a = l2.indexOf(e2);
                    int s;
                    int e;
                    if (l2.last != e2) {
                      s = l2[a].index;
                      e = l2[a + 1].index;
                    } else if (l2.last == e2) {
                      s = l2[a].index;
                      List<LHMultiLevelList> temp = _list.where((e) => e.index > s).toList();
                      if (temp.where((e) => e.level == 3).toList().length != 0) {
                        e = _list.where((e) => e.index > s).firstWhere((e) => e.level == 3).index;
                      } else {
                        e = _list.last.index;
                      }
                    }
                    List<LHMultiLevelList> seL = _list.sublist(s);
                    seL.removeAt(0);
                    int se;
                    if (seL.length > 1) {
                      se = seL.firstWhere((e) => e.level != 10).index;
                    } else {
                      se = _list.last.index;
                    }

                    List<LHMultiLevelList> l2s = _list.sublist(s, se).where((e) => e.level == 10).toList();

                    List<LHMultiLevelList> l3 = _list.sublist(s, e).where((t2) => t2.level == 4).toList();
                    return Card(
                      child: ExpansionTile(
                        leading: Text('B$_i.$_i1'),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            e2.text,
                            maxLines: 1,
                          ),
                        ),
                        subtitle: l2s.length > 0
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: l2s.map((e) => Text(e.text)).toList(),
                              )
                            : Container(),
                        children: l3.map((e2) {
                          _i2++;
                          int _i3 = 0;
                          int a = l3.indexOf(e2);
                          int s;
                          int e;
                          if (l3.last != e2) {
                            s = l3[a].index;
                            e = l3[a + 1].index;
                          } else if (l3.last == e2) {
                            s = l3[a].index;
                            List<LHMultiLevelList> temp = _list.where((e) => e.index > s).toList();
                            if (temp.where((e) => e.level == 4).toList().length != 0) {
                              e = _list.where((e) => e.index > s).firstWhere((e) => e.level == 4).index;
                            } else {
                              e = _list.last.index;
                            }
                          }
                          List<LHMultiLevelList> seL = _list.sublist(s);
                          seL.removeAt(0);
                          int se;
                          if (seL.length > 1) {
                            se = seL.firstWhere((e) => e.level != 10).index;
                          } else {
                            se = _list.last.index;
                          }
                          List<LHMultiLevelList> l3s = _list.sublist(s, se).where((e) => e.level == 10).toList();
                          List<LHMultiLevelList> l4 = _list.sublist(s, e).where((t3) => t3.level == 6).toList();
                          return Card(
                            child: ExpansionTile(
                              leading: Text('C$_i.$_i1.$_i2'),
                              title: Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: Text(
                                  e2.text,
                                  maxLines: 1,
                                ),
                              ),
                              subtitle: l3s.length > 0
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: l3s.map((e) => Text(e.text)).toList(),
                                    )
                                  : Container(),
                              children: l4.map((e4) {
                                _i3++;
                                String t = '가';
                                if (_i3 == 1) {
                                  t = '가';
                                } else if (_i3 == 2) {
                                  t = '나';
                                } else if (_i3 == 3) {
                                  t = '다';
                                } else if (_i3 == 4) {
                                  t = '라';
                                } else if (_i3 == 5) {
                                  t = '마';
                                } else if (_i3 == 6) {
                                  t = '바';
                                } else if (_i3 == 7) {
                                  t = '사';
                                } else if (_i3 == 8) {
                                  t = '아';
                                } else if (_i3 == 9) {
                                  t = '자';
                                } else if (_i3 == 10) {
                                  t = '차';
                                } else if (_i3 == 11) {
                                  t = '카';
                                } else if (_i3 == 12) {
                                  t = '타';
                                } else if (_i3 == 13) {
                                  t = '파';
                                } else if (_i3 == 14) {
                                  t = '하';
                                }
                                int _i4 = 0;
                                int a = l4.indexOf(e4);
                                int s;
                                int e;
                                if (l4.last != e4) {
                                  s = l4[a].index;
                                  e = l4[a + 1].index;
                                } else if (l4.last == e4) {
                                  s = l4[a].index;
                                  List<LHMultiLevelList> temp = _list.where((e) => e.index > s).toList();
                                  if (temp.where((e) => e.level == 6).toList().length != 0) {
                                    e = _list.where((e) => e.index > s).firstWhere((e) => e.level == 6).index;
                                  } else {
                                    e = _list.last.index;
                                  }
                                }
                                // List<LHMultiLevelList> seL = _list.sublist(s);
                                // seL.removeAt(0);
                                // int se;
                                // if(seL.length>1){
                                //   se = seL.firstWhere((e) =>e.level!=10 ).index;
                                // }else{
                                //   se = _list.last.index;
                                // }
                                // List<LHMultiLevelList> l4s = _list.sublist(s, se).where((e) => e.level == 10).toList();
                                List<LHMultiLevelList> l6 = _list.sublist(s, e).where((t3) => t3.level == 7).toList();

                                return Card(
                                  child: ExpansionTile(
                                    leading: Text('$t.'),
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 24.0),
                                      child: Text(
                                        e4.text,
                                        maxLines: 1,
                                      ),
                                    ),
                                    // subtitle: l4s.length>0?Column(
                                    //   mainAxisSize: MainAxisSize.min,
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: l4s.map((e) => Text(e.text)).toList(),
                                    // ):Container(),
                                    children: l6.map((e6) {
                                      _i4++;
                                      int _i5 = 0;
                                      int a = l6.indexOf(e6);
                                      int s;
                                      int e;
                                      if (l6.last != e6) {
                                        s = l6[a].index;
                                        e = l6[a + 1].index;
                                      } else if (l6.last == e6) {
                                        s = l6[a].index;
                                        List<LHMultiLevelList> temp = _list.where((e) => e.index > s).toList();
                                        if (temp.where((e) => e.level == 7).toList().length != 0) {
                                          e = _list.where((e) => e.index > s).firstWhere((e) => e.level == 7).index;
                                        } else {
                                          e = _list.last.index;
                                        }
                                      }
                                      // List<LHMultiLevelList> seL = _list.sublist(s);
                                      // seL.removeAt(0);
                                      // int se;
                                      // if(seL.length>1){
                                      //   se = seL.firstWhere((e) =>e.level!=10 ).index;
                                      // }else{
                                      //   se = _list.last.index;
                                      // }
                                      // List<LHMultiLevelList> l4s = _list.sublist(s, se).where((e) => e.level == 10).toList();
                                      List<LHMultiLevelList> l7 =
                                          _list.sublist(s, e).where((t3) => t3.level == 8).toList();
                                      return Card(
                                        child: ExpansionTile(
                                          leading: Text('$_i4)'),
                                          title: Text(
                                            e6.text,
                                            maxLines: 1,
                                          ),
                                          children: l7.map((e7) {
                                            _i5++;
                                            String t2 = '가';
                                            if (_i5 == 1) {
                                              t2 = '가';
                                            } else if (_i5 == 2) {
                                              t2 = '나';
                                            } else if (_i5 == 3) {
                                              t2 = '다';
                                            } else if (_i5 == 4) {
                                              t2 = '라';
                                            } else if (_i5 == 5) {
                                              t2 = '마';
                                            } else if (_i5 == 6) {
                                              t2 = '바';
                                            } else if (_i5 == 7) {
                                              t2 = '사';
                                            } else if (_i5 == 8) {
                                              t2 = '아';
                                            } else if (_i5 == 9) {
                                              t2 = '자';
                                            } else if (_i5 == 10) {
                                              t2 = '차';
                                            } else if (_i5 == 11) {
                                              t2 = '카';
                                            } else if (_i5 == 12) {
                                              t2 = '타';
                                            } else if (_i5 == 13) {
                                              t2 = '파';
                                            } else if (_i5 == 14) {
                                              t2 = '하';
                                            }

                                            return Card(
                                              child: ListTile(
                                                leading: Text('$t2)'),
                                                title: Text(
                                                  e7.text,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ).toList(),
        ),
      );
    },
  ).toList();
  return _widgets;
}
