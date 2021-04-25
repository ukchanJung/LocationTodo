import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/data/lhchecklistdoc.dart';
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
  List<CheckList> checkLists;
  List<String> f1;
  CheckList selectCheck;
  @override
  void initState() {
    super.initState();
    checkLists = qualityCheckList.map((e) => CheckList.fromMap(e)).toList();
    void read() async {
      QuerySnapshot read = await FirebaseFirestore.instance.collection('lhchecklist').get();
      data = read.docs.map((e) => e).toList();
      setState(() {});
    }
    f1 = checkLists.map((e) => e.type1).toSet().toList();
    selectCheck = checkLists.first;

    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$selectT [$index/${data.length}]'),
        actions: [
          TextButton(onPressed: (){
            setState(() {
              listLevel = [];
            });
          },child: Text('리스트초기화'),),
          TextButton(
              onPressed: () {
                Get.defaultDialog(
                    title: '대공종선택',
                    content: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              level1 = '토목';
                            });
                          },
                          child: Text('토목'),
                        ),
                      ],
                    ));
              },
              child: Text('대공종')),
          TextButton(
              onPressed: () {
                Get.defaultDialog(
                    title: '대공종선택',
                    content: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              level2 = '중요';
                            });
                          },
                          child: Text('중요'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              level2 = '일반';
                            });
                          },
                          child: Text('일반'),
                        ),
                      ],
                    ));
              },
              child: Text('중요도')),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Text('+'),
            heroTag: null,
            onPressed: () {
              setState(() async {
                isLoad = false;
                index++;
                String tempRoot = 'asset/lhchecklist/${lhCheckListDocData[index]}.png';
                ByteData bytes = await rootBundle.load(tempRoot);
                String tempPath = (await getTemporaryDirectory()).path;
                String tempName = '$tempPath/${lhCheckListDocData[index]}.png';
                File file = File(tempName);
                await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                decodeImage = decodeImageFromList(file.readAsBytesSync());
                decodeImage.then((value) {
                  iS = value.width / _keyA.currentContext.size.width;
                  decodeImage.whenComplete(() {
                    isLoad = true;
                    setState(() {});
                  });
                });
                print(data[index].data()['dataList']);
                temp = data[index].data()['dataList'];
              });
            },
          ),
          SizedBox(
            width: 24,
          ),
          FloatingActionButton(
            child: Text('-'),
            heroTag: null,
            onPressed: () {
              setState(() async {
                isLoad = false;
                index--;
                String tempRoot = 'asset/lhchecklist/${lhCheckListDocData[index]}.png';
                ByteData bytes = await rootBundle.load(tempRoot);
                String tempPath = (await getTemporaryDirectory()).path;
                String tempName = '$tempPath/${lhCheckListDocData[index]}.png';
                File file = File(tempName);
                await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                decodeImage = decodeImageFromList(file.readAsBytesSync());
                decodeImage.then((value) {
                  iS = value.width / _keyA.currentContext.size.width;
                  decodeImage.whenComplete(() {
                    isLoad = true;
                    setState(() {});
                  });
                });
                print(data[index].data()['dataList']);
                temp = data[index].data()['dataList'];
                temp2 = data[index].data()['fulltext'];
              });
            },
          ),
          SizedBox(
            width: 24,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {});
            },
            heroTag: null,
            child: Icon(Icons.refresh),
          ),
          SizedBox(
            width: 24,
          ),
          FloatingActionButton(onPressed: () {
            setState(() {
              selectCheck..checkListDetail=listLevel;
              FirebaseFirestore.instance.collection('lhCheckListDocFin').doc(selectCheck.toString()).set(selectCheck.toMap());
              listLevel = [];
            });
          }),
          // FloatingActionButton(onPressed: () {
          //   setState(() {
          //     StandardDetail _sD = StandardDetail();
          //     _sD
          //       ..name = selectT
          //       ..type = standarddetail[index]['type']
          //       ..index1 = standarddetail[index]['index1']
          //       ..index2 = standarddetail[index]['index2']
          //       ..index3 = standarddetail[index]['index3']
          //       ..fulltext = temp2
          //       ..path = standarddetail[index]['path'];
          //     print(_sD);
          //     FirebaseFirestore.instance.collection('detailData').doc(_sD.path).set(_sD.toJson());
          //   });
          // }),
        ],
      ),
      body: Row(
        children: [
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
                            // if (key.character == '6') {
                            //   level1 = selectText;
                            // }
                            // if (key.character == '2') {
                            //   level2 = selectText;
                            // }
                            // if (key.character == '3') {
                            //   level3 = selectText;
                            // }
                            // if (key.character == '4') {
                            //   level4 = selectText;
                            // }
                            // if (key.character == '5') {
                            //   level5 = selectText;
                            // }
                            if (key.character == '1'&&key.data.isControlPressed) {
                              Map temp = {'level1': selectText};
                              // Map temp = {'level1': selectText.replaceAll("\n", "")};
                              listLevel.add(temp);
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
          Container(
            width: 500,
            child: Scrollbar(
              child: ListView(
                children: f1.map((a) {
                  return ExpansionTile(
                    title: Text(a),
                    children: checkLists.where((e) => e.type1 == a).map((e) => e.type2).toSet().map((b) {
                      List<CheckList> f2 = checkLists.where((e) => e.type2 == b).toList();
                      return ExpansionTile(
                        title: Text(b),
                        children: f2
                            .map((e) =>
                            ListTile(
                              title: Text(e.timing),
                              subtitle: Text(e.checkList),
                              onTap: () {
                                setState(() {
                                  selectCheck =e;
                                });
                              },
                            ))
                            .toList(),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            )
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Card(child: ListTile(leading: Text('공사명'), title: AutoSizeText(selectCheck.type1, maxLines: 1))),
                  Card(child: ListTile(leading: Text('중요도'), title: AutoSizeText(level2, maxLines: 1))),
                  Card(child: ListTile(leading: Text('공종'), title: AutoSizeText(selectCheck.type2, maxLines: 1))),
                  Card(child: ListTile(leading: Text('세부공종'), title: AutoSizeText(selectCheck.timing, maxLines: 1))),
                  Expanded(
                    child: Card(
                      color: Colors.white54,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Scrollbar(
                          isAlwaysShown: true,
                          thickness: 20,
                          child: ListView(
                            children: listLevel
                                .map((e) => Card(
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
                                            actions:[
                                              ElevatedButton(onPressed: (){
                                                setState(() {
                                                  e['level1'] = _textEditingController.text;
                                                  Get.back();
                                                });
                                              }, child: Text('수정')),
                                              ElevatedButton(onPressed: (){
                                                Get.back();
                                              }, child: Text('취소')),
                                            ],
                                          );
                                        });
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          listLevel.remove(e);
                                        });
                                      },
                                      leading: Text((listLevel.indexOf(e)+1).toString()),
                                      title: Text(e['level1']),
                                      // subtitle: AutoSizeText(e['level2'], maxLines: 1),
                                    )))
                                .toList(),
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
}
