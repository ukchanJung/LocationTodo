import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_location_todo/data/quailty_data.dart';
import 'package:flutter_app_location_todo/model/checklist_model.dart';
import 'package:flutter_app_location_todo/model/quality_check_image_model.dart';
import 'package:flutter_app_location_todo/provider/firebase_provider.dart';
import 'package:flutter_app_location_todo/ui/pincode_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app_location_todo/model/doc_confirm_class.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ConfirmPage extends StatefulWidget {
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  TextStyle titleText = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  TextStyle boldText = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  TextStyle textStyle2 = TextStyle(fontSize: 14);
  TextStyle textStyle3 = TextStyle(fontSize: 16);
  DateFormat format = DateFormat('yyyy.MM.dd');
  DateFormat format2 = DateFormat('yyMMdd');
  String nullText = '';
  List<CheckList> checkLists;
  ConstructConfirm doc;

  String recepit = '선택해주세요';
  List<String> cheifLists =['선택하세요', '광명/시흥 본부', '인천지역본부', '충청지역본부'];
  bool _isLocalAuth;
  String _authorized = '(sign)';
  String _authorized2 = '(sign)';
  String _authorized3 = '(sign)';
  File file = File('');

  Uint8List temp;
  List<Uint8List> temps;
  File _image;
  PickedFile image;
  String value;
  List<String> paths;
  List<String> names;
  List<PlatformFile> pickFiles;
  double cardHeight = 50;
  String docId;

  User _user;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  String dMemo='';
  String cMemo='';
  List<String> category1 = ['토목공사', '건축분야', '기계분야', '전기분야', '통신분야', '조경분야'];
  List<QueryDocumentSnapshot> data2 = [];


  checkBio() async {
    var isLocalAuth;
    isLocalAuth = await LocalAuthentication().canCheckBiometrics;
    setState(() {
      _isLocalAuth = isLocalAuth;
    });
  }

  @override
  void initState() {
    super.initState();
    _user = context.read<FirebaseProvider>().getUser();
    checkLists = qualityCheckList.map((e) => CheckList.fromMap(e)).toList();
    // checkBio();
    void read2() async {
      QuerySnapshot read = await FirebaseFirestore.instance.collection('lhCheckListDocFin').get();
      data2 = read.docs.map((e) => e).toList();
      setState(() {});
    }
    read2();

    if(Get.arguments == null){
      doc = ConstructConfirm(
        checkListsId: [],
        recipient: '선택하세요',
        siteName: '시흥 장현 A6',
        applyDate: DateTime.now(),
        confirmDate: DateTime.now().add(Duration(days: 1)),
        quailtyManager1: '정욱찬',
        quailtyManager2: '강지원',
        quailtyManager3: '최진원',
        quailtyManagerCheck1: false,
        quailtyManagerCheck2: false,
        quailtyManagerCheck3: false,
        cheif1: '정욱찬',
        cheif2: '강지원',
        cheif3: '최진원',
        cheifCheck1: false,
        cheifCheck2: false,
        cheifCheck3: false,
        director: '송정훈',
        directorCheck1: false,
        confirmMemo: '',
        checkMemo:''
      );
      doc.docId = '${format2.format(DateTime.now())}_01';
    }else{
      setState(() {
      doc = Get.arguments;
      _textEditingController.text =doc.checkMemo;
      _textEditingController2.text =doc.confirmMemo;
      print(doc.checkListsId.first.checkList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery
        .of(context)
        .size
        .shortestSide;
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    if (shortestSide < 800) {
      return Scaffold(
          appBar: AppBar(
            title: Text('LH스마트 품질 검측'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
            child: Container(
              child: ListView(
                children: [
                  buildDocNum(),
                  buildCommandCenter(),
                  buildRequestDate(),
                  buildConstructTile(),
                  buildCheckTime(),
                  buildCheckBoundary(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('위 공사에 대한 시공확인을 요청합니다.', style: textStyle2),
                      ),
                    ],
                  ),
                  buildQualityManager(),
                  buildCheifManager(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.grey[450],
                      thickness: 1.5,
                    ),
                  ),
                  buildDerectorCheckDays2(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('시공확인 체크리스트', style: boldText),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: AutoSizeText('아래 부적합 사항에 대하여 시정하고 공사감독자의\n재확인을받으시기 바랍니다.', maxLines: 2, style: textStyle2),
                  ),
                  // buildCheckList(),
                  // buildErrorList(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('시공확인이 완료되었으므로\n후속공사를 추진하시기 바랍니다.', style: textStyle2),
                  ),
                  Divider(),
                  Column(
                    children: [
                      Text('건설사업관리기술자/공사감독자', style: boldText),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('송ㅇㅇ', style: textStyle2),
                          TextButton(onPressed: () {}, child: Text('(sign)', style: textStyle2))
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('품질관리자 검사내용', style: boldText),
                    ],
                  ),
                  Card(
                      child: Container(
                        height: 150,
                      )),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       // OutlinedButton(onPressed: (){}, child: Text('해당부위 도서')),
                  //       // OutlinedButton(onPressed: (){}, child: Text('사진대지')),
                  //       // OutlinedButton(onPressed: (){}, child: Text('공사참여자 설명부')),
                  //       // OutlinedButton(onPressed: (){}, child: Text('근로계약서')),
                  //       Text('첨부 : ', style: textStyle2),
                  //       file != null ? Text('${file.path}') : Container(),
                  //       IconButton(
                  //           icon: Icon(Icons.add),
                  //           onPressed: () async {
                  //             FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);
                  //             if (result != null) {
                  //               setState(() {
                  //                 temps = result.files.map((e) => e.bytes).toList();
                  //                 print(temps);
                  //                 temp = result.files.first.bytes;
                  //                 value = result.files.first.path.toString();
                  //               });
                  //             } else {
                  //               // User canceled the picker
                  //             }
                  //           }),
                  //     ],
                  //   ),
                  // ),
                  // temps != null ? Text(value) : Container(),
                  // temps != null && kIsWeb
                  //     ? Row(
                  //     children: temps
                  //         .map(
                  //           (e) =>
                  //           Expanded(
                  //             child: Image.memory(e),
                  //           ),
                  //     )
                  //         .toList())
                  //     : Container(),
                  // // file !=null?Image.file(file,width: 500,fit: BoxFit.fitWidth,):Container(),
                  // // file !=null?Text(temp.toString()):Container(),
                ],
              ),
            ),
          ));
    } else if (shortestSide > 800 && shortestSide < 1100 && !kIsWeb) {
      return Scaffold(
          appBar: AppBar(
            title: Text('공사 시공 확인서', style: titleText),
            actions: [
              TextButton(onPressed: () {}, child: Text('결재', style: titleText)),
              TextButton(
                  onPressed: ()  {
                     docDataUpload();
                  },
                  child: Text('확인'))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 54.0, right: 54, bottom: 24, top: 8),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 900,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: buildDocNum(),
                            ),
                            Expanded(
                              child: buildCommandCenter(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildRequestDate(),
                            ),
                            Expanded(
                              child: buildConstructTile(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildCheckTime(),
                            ),
                            Expanded(
                              child: buildCheckBoundary(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('위 공사에 대한 시공확인을 요청합니다.', style: textStyle2),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildQualityManager(),
                            ),
                            Expanded(
                              child: buildCheifManager(),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            color: Colors.grey[450],
                            thickness: 1.5,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildDerectorCheckDays(),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('시공확인 체크리스트', style: boldText),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('아래 부적합 사항에 대하여 시정하고 공사감독자의 재확인을 받으시기 바랍니다.', style: textStyle2),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: buildCheckList(),
                                ),
                                Expanded(
                                  child: buildErrorList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('시공확인이 완료되었으므로 후속공사를 추진하시기 바랍니다.', style: textStyle2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('건설사업관리기술자/공사감독자 :', style: boldText),
                            Container(width: 150, child: Center(child: Text('정욱찬', style: textStyle3))),
                            doc.directorCheck1
                                ? Image.asset(
                                    'asset/photos/ukchansign.png',
                                    width: 80,
                                  )
                                : TextButton(
                                    onPressed: () async {
                                      final result = await Get.to(PinCodeVerificationScreen('01035027206'));
                                      setState(() {
                                        doc.directorCheck1 = result;
                                      });
                                    },
                                    child: Text('(sign)', style: textStyle2))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('품질관리자 검사내용', style: boldText),
                          ],
                        ),
                        Container(height: 16,),
                        buildCheckMemo(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('※ 첨부 : ', style: textStyle2),
                              file != null ? Text('${file.path}') : Container(),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: OutlinedButton(
                                    onPressed: () async {
                                      FilePickerResult result =
                                      await FilePicker.platform.pickFiles(allowMultiple: true);
                                      if (result != null) {
                                        setState(() {
                                          temps = result.files.map((e) => e.bytes).toList();
                                          value = result.files.first.path.toString();
                                          paths = result.files.map((e) => e.path).toList();
                                          names = result.files.map((e) => e.name).toList();
                                          pickFiles = result.files;
                                          if (!kIsWeb) {
                                            Get.defaultDialog(
                                                title: '첨부 도면',
                                                content: Container(
                                                  width: 600,
                                                  height: 800,
                                                  child: Wrap(
                                                    children: pickFiles.map((e) {
                                                      print(e.path);
                                                      print(e.bytes);
                                                      return InkWell(
                                                        onTap: () {
                                                          Get.defaultDialog(
                                                              title: e.name,
                                                              content: Container(
                                                                  width: 600,
                                                                  height: 800,
                                                                  child: Image.file(File(e.path))));
                                                        },
                                                        child: Card(
                                                          elevation: 3,
                                                          child: Container(
                                                            width: 200,
                                                            child: Column(
                                                              children: [
                                                                Image.file(
                                                                  File(e.path),
                                                                  fit: BoxFit.fitWidth,
                                                                ),
                                                                ListTile(title: Text(e.name))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ));
                                          } else if (kIsWeb) {
                                            Get.defaultDialog(
                                                title: '첨부 도면',
                                                content: Container(
                                                    width: 600,
                                                    height: 800,
                                                    child: Column(
                                                      children: temps.map((e) => Image.memory(e)).toList(),
                                                    )));
                                          }
                                        });
                                      } else {
                                        // User canceled the picker
                                      }
                                    },
                                    child: Text('첨부도면')),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: OutlinedButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                          title: '사진대지',
                                          content: Container(
                                            width: 800,
                                            height: 1200,
                                            child: ListView(
                                              children: doc.checkListsId
                                                  .map((e) =>
                                                  ExpansionTile(
                                                    initiallyExpanded: true,
                                                    title: Text(e.checkList),
                                                    subtitle: Text(e.timing),
                                                    children: e.qualityCheckImages
                                                        .map((e) =>
                                                        Card(
                                                          child: ListTile(
                                                            title: Text(e.title),
                                                            subtitle: e.image,
                                                          ),
                                                        ))
                                                        .toList(),
                                                  ))
                                                  .toList(),
                                            ),
                                          ));
                                    },
                                    child: Text('사진대지')),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: OutlinedButton(onPressed: () {}, child: Text('참여자 실명부')),
                              ),
                            ],
                          ),
                        ),
                        // if (temps != null && kIsWeb)
                        //   Row(
                        //       children: temps
                        //           .map((e) => Expanded(
                        //                 child: Image.memory(e),
                        //               ))
                        //           .toList())
                        // else if (temps != null && !kIsWeb)
                        //   Row(
                        //       children: paths
                        //           .map((e) => Expanded(
                        //                 child: Image.file(File(e)),
                        //               ))
                        //           .toList())
                        // else
                        //   Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    } else if (deviceWidth > 1440) {
      return Scaffold(
          appBar: AppBar(
            title: Text('공사 시공 확인서', style: titleText),
            actions: [
              TextButton(onPressed: () {}, child: Text('결재', style: titleText)),
              TextButton(
                  onPressed: () {
                     docDataUpload();
                  },
                  child: Text('확인'))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 54.0, right: 54, bottom: 24, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 768,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildDocNum(),
                          ),
                          Expanded(
                            child: buildCommandCenter(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildRequestDate(),
                          ),
                          Expanded(
                            child: buildConstructTile(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildCheckTime(),
                          ),
                          Expanded(
                            child: buildCheckBoundary(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('위 공사에 대한 시공확인을 요청합니다.', style: textStyle2),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildQualityManager(),
                          ),
                          Expanded(
                            child: buildCheifManager(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: Colors.grey[450],
                          thickness: 1.5,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildDerectorCheckDays(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('시공확인 체크리스트', style: boldText),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('아래 부적합 사항에 대하여 시정하고 공사감독자의 재확인을 받으시기 바랍니다.', style: textStyle2),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: buildCheckList(),
                            ),
                            Expanded(
                              child: buildErrorList(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('시공확인이 완료되었으므로 후속공사를 추진하시기 바랍니다.', style: textStyle2),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('건설사업관리기술자/공사감독자 :', style: boldText),
                          Container(width: 150, child: Center(child: Text('정욱찬', style: textStyle3))),
                          doc.directorCheck1
                              ? Image.asset(
                            'asset/photos/ukchansign.png',
                            width: 80,
                          )
                              : TextButton(
                            onPressed: () async {
                              final result = await Get.to(PinCodeVerificationScreen('01035027206'));
                              setState(() {
                                doc.directorCheck1 = result;
                              });
                            },
                            child: Text('(sign)', style: textStyle2))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('품질관리자 검사내용', style: boldText),
                        ],
                      ),
                      Container(height: 16,),
                      buildCheckMemo(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('※ 첨부 : ', style: textStyle2),
                            file != null ? Text('${file.path}') : Container(),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: OutlinedButton(
                                  onPressed: () async {
                                    FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);
                                    if (result != null) {
                                      setState(() {
                                        temps = result.files.map((e) => e.bytes).toList();
                                        value = result.files.first.path.toString();
                                        paths = result.files.map((e) => e.path).toList();
                                        names = result.files.map((e) => e.name).toList();
                                        pickFiles = result.files;
                                        if (!kIsWeb) {
                                          Get.defaultDialog(
                                              title: '첨부 도면',
                                              content: Container(
                                                width: 600,
                                                height: 800,
                                                child: Wrap(
                                                  children: pickFiles.map((e) {
                                                    print(e.path);
                                                    print(e.bytes);
                                                    return InkWell(
                                                      onTap: () {
                                                        Get.defaultDialog(
                                                            title: e.name,
                                                            content: Container(
                                                                width: 600,
                                                                height: 800,
                                                                child: Image.file(File(e.path))));
                                                      },
                                                      child: Card(
                                                        elevation: 3,
                                                        child: Container(
                                                          width: 200,
                                                          child: Column(
                                                            children: [
                                                              Image.file(
                                                                File(e.path),
                                                                fit: BoxFit.fitWidth,
                                                              ),
                                                              ListTile(title: Text(e.name))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ));
                                        } else if (kIsWeb) {
                                          Get.defaultDialog(
                                              title: '첨부 도면',
                                              content: Container(
                                                width: 600,
                                                height: 800,
                                                child: Wrap(
                                                  children: pickFiles.map((e) {
                                                    print(e.path);
                                                    print(e.bytes);
                                                    return InkWell(
                                                      onTap: () {
                                                        Get.defaultDialog(
                                                            title: e.name,
                                                            content: Container(
                                                                width: 600, height: 800, child: Image.memory(e.bytes)));
                                                      },
                                                      child: Card(
                                                        elevation: 3,
                                                        child: Container(
                                                          width: 200,
                                                          child: Column(
                                                            children: [
                                                              Image.memory(
                                                                e.bytes,
                                                                fit: BoxFit.fitWidth,
                                                              ),
                                                              ListTile(title: Text(e.name))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ));
                                          ;
                                        }
                                      });
                                    } else {
                                      // User canceled the picker
                                    }
                                  },
                                  child: Text('첨부도면')),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: OutlinedButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: '사진대지',
                                        content: Container(
                                          width: 800,
                                          height: 900,
                                          child: ListView(
                                            children: doc.checkListsId
                                                .map((e) =>
                                                ExpansionTile(
                                                  initiallyExpanded: true,
                                                  title: Text(e.checkList),
                                                  subtitle: Text(e.timing),
                                                  children: e.qualityCheckImages
                                                      .map((e) =>
                                                      Card(
                                                        child: ListTile(
                                                          title: Text(e.title),
                                                          subtitle: e.image,
                                                        ),
                                                      ))
                                                      .toList(),
                                                ))
                                                .toList(),
                                          ),
                                        ));
                                  },
                                  child: Text('사진대지')),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: OutlinedButton(onPressed: () {}, child: Text('참여자 실명부')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    }
  }

  Container buildCheckMemo() {
    return Container(
                        height: 100,
                        child: TextField(
                          onChanged: (t){
                            setState(() {
                              doc.checkMemo = t;
                            });
                          },
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '검사 내용을 입력해 주세요',
                          ),
                        ),
                      );
  }

  Future docDataUpload()  async {
    if(!kIsWeb){
      for (int a = 0; a<doc.checkListsId.length; a++){
        for(int b =0; b<doc.checkListsId[a].qualityCheckImages.length; b++) {
          print('1');
          QuailtyCheckImage i = doc.checkListsId[a].qualityCheckImages[b];
          print('2');
          Reference storageReference = _firebaseStorage.ref("test/${_user.uid}/${i.fileName}_${DateTime.now()}");
          print('3');
          UploadTask storageUploadTask = storageReference.putFile(
            File(i.localPath),
            SettableMetadata(contentType: 'image/jpeg'),
          );
          print('4');
          await storageUploadTask;
          print('5');
          i.serverPath = await storageReference.getDownloadURL();
        }
      }
      var uuid = Uuid().v1();
      doc.uid =uuid;
      FirebaseFirestore _db = FirebaseFirestore.instance;
      CollectionReference dbGrid = _db.collection('docTest');
      print('6');
      dbGrid.doc(uuid).set(doc.toJson());
      Get.back();

    }else if(kIsWeb){
      for (int a = 0; a<doc.checkListsId.length; a++){
        for(int b =0; b<doc.checkListsId[a].qualityCheckImages.length; b++) {
          print('1');
          QuailtyCheckImage i = doc.checkListsId[a].qualityCheckImages[b];
          print('2');
          Reference storageReference = _firebaseStorage.ref("test/${_user.uid}/${i.fileName}_${DateTime.now()}");
          print('3');
          UploadTask storageUploadTask = storageReference.putData(
            i.uint8list,
            SettableMetadata(contentType: 'image/jpeg'),
          );

          print('4');
          await storageUploadTask;
          print('5');
          i.serverPath = await storageReference.getDownloadURL();
        }
      }
      var uuid = Uuid().v1();
      doc.uid =uuid;
      FirebaseFirestore _db = FirebaseFirestore.instance;
      CollectionReference dbGrid = _db.collection('docTest');
      print('6');
      dbGrid.doc(uuid).set(doc.toJson());
      Get.back();

      // doc.checkListsId.forEach((e) {
      //   e.qualityCheckImages.forEach((i) {
      //     // 파일 업로드
      //     print('1');
      //     Reference storageReference = _firebaseStorage.ref("test/${_user.uid}/${i.fileName}_${DateTime.now()}");
      //     UploadTask storageUploadTask = storageReference.putData(i.uint8list,SettableMetadata(contentType: 'image/jpeg'));
      //     print('2');
      //     // 파일 업로드 완료까지 대기
      //     storageUploadTask.whenComplete(() async {
      //       // 업로드한 사진의 URL 획득
      //     print('3');
      //
      //     String downloadURL = await storageReference.getDownloadURL();
      //       // 업로드된 사진의 URL을 페이지에 반영
      //       i.serverPath = downloadURL;
      //       print('4');
      //     }).then((_) {
      //       FirebaseFirestore _db = FirebaseFirestore.instance;
      //       CollectionReference dbGrid = _db.collection('docTest');
      //       dbGrid.doc('1').set(doc.toJson());
      //     });
      //   });
      // });
    }

  }

  void pickImageFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        temps = result.files.map((e) => e.bytes).toList();
        value = result.files.first.path.toString();
        paths = result.files.map((e) => e.path).toList();
      });
    } else {
      // User canceled the picker
    }
  }

  Card buildErrorList() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Center(child: Text('부적합사항', style: boldText)),
            leading: Container(width: 32,),
            // trailing: IconButton(icon: Icon(Icons.add), onPressed: (){
            //   setState(() {
            //   doc.confirmMemo.add('');
            //   });
            // }),
          ),
          Divider(
            thickness: 2,
            height: 10,
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textEditingController2,
              onChanged: (t){
                setState(() {
                  doc.confirmMemo = t;
                });
              },
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ))

        ],
      ),
    );
  }

  Card buildCheckList() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Center(child: Text('주요 검사항목 (체크리스트)', style: boldText)),
            leading: Container(
              width: 32,
            ),
            trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  List<String> f1 = checkLists.map((e) => e.type1).toSet().toList();
                  Get.defaultDialog(
                      title: '체크리스트',
                      content: Container(
                        width: 500,
                        height: 600,
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
                                              if(!doc.checkListsId.contains(e)){
                                              doc.checkListsId.add(e);
                                              }
                                            });
                                            Get.back();
                                          },
                                        ))
                                        .toList(),
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),
                        ),
                      ));
                }),
          ),
          Divider(
            thickness: 2,
            height: 10,
          ),
          doc.checkListsId != []
              ? Expanded(
              child: ListView(
                children: doc.checkListsId
                    .map(
                      (e) =>
                      Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: ExpansionTile(
                          title: Text(e.checkList),
                          subtitle: Text(e.timing),
                          leading: Checkbox(
                            value: e.check,
                            onChanged: (value) {
                              setState(() {
                                e.check = !e.check;
                              });
                            },
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.add_photo_alternate),
                              onPressed: () async {
                                FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);
                                print(result.names);
                                if (result != null) {
                                  setState(() {
                                    pickFiles = result.files;
                                    if (!kIsWeb) {
                                      e.qualityCheckImages.addAll(pickFiles
                                          .map((e) =>
                                          QuailtyCheckImage(
                                            title: '테스트',
                                            image: Image.file(
                                              File(e.path),
                                              fit: BoxFit.scaleDown,
                                            ),
                                            location: '테스트 위치',
                                            createTime: DateTime.now(),
                                            localPath: e.path,
                                            uint8list: e.bytes,
                                            fileName: e.name,
                                          ))
                                          .toList());
                                    } else if (kIsWeb) {
                                      e.qualityCheckImages.addAll(pickFiles
                                          .map((e) =>
                                          QuailtyCheckImage(
                                            title: '테스트',
                                            image: Image.memory(e.bytes),
                                            location: '테스트 위치',
                                            createTime: DateTime.now(),
                                            uint8list: e.bytes,
                                            fileName: e.name,
                                          ))
                                          .toList());
                                    }
                                  });
                                } else {
                                  // User canceled the picker
                                }
                              }),
                          children: e.qualityCheckImages
                              .map((e) =>
                              ListTile(
                                title: Text(e.title),
                                // subtitle: Text(e.location),
                                trailing: Text(format.format(e.createTime)),
                                leading: Container(
                                  height: 150,
                                  child: e.image,
                                ),
                                onTap: () {
                                  Get.defaultDialog(title: e.title, content: e.image);
                                },
                              ))
                              .toList(),
                        ),
                        secondaryActions: [
                          IconSlideAction(
                            caption: '삭제',
                            color: Colors.red,
                            icon:Icons.delete,
                            onTap: (){
                              Get.defaultDialog(title: '정말 삭제하시겠습니까',
                                      content: ListTile(
                                        title: Text(e.checkList),
                                        subtitle: Text(e.timing),
                                      ),
                                      actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      doc.checkListsId.remove(e);
                                      Get.back();
                                    },
                                    child: Text('삭제'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text('취소'),
                                  ),
                                ]).then((_){setState(() {

                                });});
                            },
                          ),
                        ],
                      ),
                )
                    .toList(),
              ))
              : Container()
              // ? Expanded(
              // child: ListView(
              //   children: doc.checkListsId
              //       .map(
              //         (e) =>
              //         Slidable(
              //           actionPane: SlidableDrawerActionPane(),
              //           actionExtentRatio: 0.25,
              //           child: ExpansionTile(
              //             title: Text(e.checkList),
              //             subtitle: Text(e.timing),
              //             leading: Checkbox(
              //               value: e.check,
              //               onChanged: (value) {
              //                 setState(() {
              //                   e.check = !e.check;
              //                 });
              //               },
              //             ),
              //             trailing: IconButton(
              //                 icon: Icon(Icons.add_photo_alternate),
              //                 onPressed: () async {
              //                   FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);
              //                   print(result.names);
              //                   if (result != null) {
              //                     setState(() {
              //                       pickFiles = result.files;
              //                       if (!kIsWeb) {
              //                         e.qualityCheckImages.addAll(pickFiles
              //                             .map((e) =>
              //                             QuailtyCheckImage(
              //                               title: '테스트',
              //                               image: Image.file(
              //                                 File(e.path),
              //                                 fit: BoxFit.scaleDown,
              //                               ),
              //                               location: '테스트 위치',
              //                               createTime: DateTime.now(),
              //                               localPath: e.path,
              //                               uint8list: e.bytes,
              //                               fileName: e.name,
              //                             ))
              //                             .toList());
              //                       } else if (kIsWeb) {
              //                         e.qualityCheckImages.addAll(pickFiles
              //                             .map((e) =>
              //                             QuailtyCheckImage(
              //                               title: '테스트',
              //                               image: Image.memory(e.bytes),
              //                               location: '테스트 위치',
              //                               createTime: DateTime.now(),
              //                               uint8list: e.bytes,
              //                               fileName: e.name,
              //                             ))
              //                             .toList());
              //                       }
              //                     });
              //                   } else {
              //                     // User canceled the picker
              //                   }
              //                 }),
              //             children: e.qualityCheckImages
              //                 .map((e) =>
              //                 ListTile(
              //                   title: Text(e.title),
              //                   // subtitle: Text(e.location),
              //                   trailing: Text(format.format(e.createTime)),
              //                   leading: Container(
              //                     height: 150,
              //                     child: e.image,
              //                   ),
              //                   onTap: () {
              //                     Get.defaultDialog(title: e.title, content: e.image);
              //                   },
              //                 ))
              //                 .toList(),
              //           ),
              //           secondaryActions: [
              //             IconSlideAction(
              //               caption: '삭제',
              //               color: Colors.red,
              //               icon:Icons.delete,
              //               onTap: (){
              //                 Get.defaultDialog(title: '정말 삭제하시겠습니까',
              //                         content: ListTile(
              //                           title: Text(e.checkList),
              //                           subtitle: Text(e.timing),
              //                         ),
              //                         actions: [
              //                     OutlinedButton(
              //                       onPressed: () {
              //                         doc.checkListsId.remove(e);
              //                         Get.back();
              //                       },
              //                       child: Text('삭제'),
              //                     ),
              //                     OutlinedButton(
              //                       onPressed: () {
              //                         Get.back();
              //                       },
              //                       child: Text('취소'),
              //                     ),
              //                   ]).then((_){setState(() {
              //
              //                   });});
              //               },
              //             ),
              //           ],
              //         ),
              //   )
              //       .toList(),
              // ))
              // : Container()
        ],
      ),
    );
  }

  Card buildDerectorCheckDays() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: cardHeight,
          child: Row(
            children: [
              Text('공사 감독자의 검사일', style: boldText),
              Text(' : ', style: textStyle2),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Future<DateTime> requestD = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365)));
                        requestD.then((value) {
                          if (value != null) {
                            setState(() {
                              doc.checkD1 = value;
                            });
                          }
                        });
                      },
                      child: Text(
                        '1차 : ${doc.checkD1 != null ? format.format(doc.checkD1) : '지정'}',
                        style: textStyle2,
                      ),
                    ),
                    doc.checkD1!=null?
                    TextButton(
                      onPressed: () {
                        Future<DateTime> requestD = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365)));
                        requestD.then((value) {
                          if (value != null) {
                            setState(() {
                              doc.checkD2 = value;
                            });
                          }
                        });
                      },
                      child: Text(
                        '2차 : ${doc.checkD2 != null ? format.format(doc.checkD2) : '지정'}',
                        style: textStyle2,
                      ),
                    ):Container(),
                    doc.checkD2 !=null?
                    TextButton(
                        onPressed: () {
                          Future<DateTime> requestD = showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now().add(Duration(days: 365)));
                          requestD.then((value) {
                            if (value != null) {
                              setState(() {
                                doc.checkD3 = value;
                              });
                            }
                          });
                        },
                      child: Text(
                        '3차 : ${doc.checkD3 != null ? format.format(doc.checkD3) : '지정'}',
                        style: textStyle2,
                      )
                    ):Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildDerectorCheckDays2() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('공사 감독자의 검사일', style: boldText),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('1차 : ${format.format(DateTime.now())}', style: textStyle2),
                      Text('2차 : ${format.format(DateTime.now())}', style: textStyle2),
                      Text('3차 : ${format.format(DateTime.now())}', style: textStyle2),
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

  Card buildCheifManager() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 130,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('현', style: boldText),
                    Text('장', style: boldText),
                    Text('대', style: boldText),
                    Text('리', style: boldText),
                    Text('인', style: boldText),
                  ],
                ),
              ),
              Container(
                  height: 45,
                  child: Row(
                    children: [
                      Text(' : ', style: textStyle2),
                    ],
                  )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('1차', style: textStyle2),
                        Text(doc.cheif1, style: textStyle2),
                        TextButton(onPressed: () {
                          setState(() {
                            LocalAuthMethod(doc.cheifCheck1);
                          });
                        }, child: Text(doc.cheifCheck1?'서명완료':'서명실패', style: textStyle2))
                      ],
                    ),
                    doc.cheifCheck1?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('2차', style: textStyle2),
                        Text(doc.cheif2, style: textStyle2),
                        TextButton(onPressed: () {
                          setState(() {
                            LocalAuthMethod(doc.cheifCheck2);
                          });
                        }, child: Text(doc.cheifCheck2?'서명완료':'서명실패', style: textStyle2))
                      ],
                    ):Container(),
                    doc.cheifCheck2?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('3차', style: textStyle2),
                        Text(doc.cheif3, style: textStyle2),
                        TextButton(onPressed: () {
                          setState(() {
                            LocalAuthMethod(doc.cheifCheck3);
                          });
                        }, child: Text(doc.cheifCheck3?'서명완료':'서명실패', style: textStyle2))
                      ],
                    ):Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildQualityManager() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 130,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('품', style: boldText),
                    Text('질', style: boldText),
                    Text('관', style: boldText),
                    Text('리', style: boldText),
                    Text('자', style: boldText),
                  ],
                ),
              ),
              Container(
                  height: 45,
                  child: Row(
                    children: [
                      Text(' : ', style: textStyle2),
                    ],
                  )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('1차', style: textStyle2),
                        Text(doc.quailtyManager1, style: textStyle2),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                LocalAuthMethod(doc.quailtyManagerCheck1);
                              });
                              setState(() {

                              });
                            },
                            child: Text(doc.quailtyManagerCheck1?'서명완료':'서명실패', style: textStyle2))
                      ],
                    ),
                    doc.quailtyManagerCheck1?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('2차', style: textStyle2),
                        Text('정ㅇㅇ', style: textStyle2),
                        TextButton(
                            onPressed: () {
                              setState(() {
                              LocalAuthMethod(doc.quailtyManagerCheck2);
                              });
                            },
                            child: Text(doc.quailtyManagerCheck2?'서명완료':'서명실패', style: textStyle2))
                      ],
                    ):Container(),
                    doc.quailtyManagerCheck2?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('3차', style: textStyle2),
                        Text('이ㅇㅇ', style: textStyle2),
                        TextButton(
                            onPressed: () async {
                              final result = await Get.to(PinCodeVerificationScreen('01035027206'));
                              setState(() {
                                doc.quailtyManagerCheck3 = result;
                              });
                            },
                            child: Text(doc.quailtyManagerCheck3?'서명완료':'서명실패', style: textStyle2))
                      ],
                    ):Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool LocalAuthMethod(check) {
    bool confirm;
    Future<bool> authenticated;
    authenticated =
        LocalAuthentication().authenticateWithBiometrics(localizedReason: '생체인식을 진행해주세요');
    authenticated.then((value) {
      setState(() {
        check = value ;
        confirm = value ;
      });
    });
    return confirm;
  }

  String localAuth() {
    String result;
    Future<bool> authenticated;
    authenticated = LocalAuthentication().authenticateWithBiometrics(localizedReason: '생체인식을 진행해주세요');
    authenticated.then((value) {
      setState(() {
        result = value ? '서명완료' : '서명실패';
      });
    });
    return result;
  }

  Card buildCheckBoundary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: cardHeight,
          child: Row(
            children: [
              Container(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('검', style: boldText),
                    Text('사', style: boldText),
                    Text('범', style: boldText),
                    Text('위', style: boldText),
                  ],
                ),
              ),
              Text(' : ', style: textStyle2),
              Text('작업범위별', style: textStyle2),
            ],
          ),
        ),
      ),
    );
  }

  Card buildCheckTime() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: cardHeight,
          child: Row(
            children: [
              Container(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('시', style: boldText),
                    Text('공', style: boldText),
                    Text('확', style: boldText),
                    Text('인', style: boldText),
                    Text('시', style: boldText),
                    Text('점', style: boldText),
                  ],
                ),
              ),
              Text(' : ', style: textStyle2),
              TextButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: '시공확인시점',
                    content: Container(
                      width: 600,
                      height: 800,
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
                                        String t='';
                                        l3.forEach((element) {
                                          t = t+element['level1']+'\n';
                                        });
                                        return Card(
                                          child: ListTile(
                                            title: Text(e.data()['timing']),
                                            trailing: Tooltip(message:t,child: Text('미리보기')),
                                            onTap: (){
                                              setState(() {
                                                doc.checkListsId.add(CheckList.fromMap(e.data()));
                                                Get.back();
                                              });
                                            },
                                            // children: l3.map((e) {
                                            //   String i = e['index'].toString();
                                            //   List<String > indexParse =[];
                                            //   if(e['index']!=null){
                                            //     List indexData =  e['index'];
                                            //     indexParse = indexData.map((e) {
                                            //       String t = e['name'];
                                            //       if(e['2']!=null)t=t+ '_'+e['2']+'.';
                                            //       if(e['3']!=null)t=t+ e['3']+'.';
                                            //       if(e['4']!=null)t=t+ e['4']+'.';
                                            //       if(e['6']!=null)t=t+ e['6']+'.';
                                            //       if(e['7']!=null)t=t+ e['7']+')';
                                            //       // t = '${e['name']}_${e['2']}.${e['3']}.${e['4']}_${e['6']}_${e['7']}';
                                            //       return t;
                                            //     }).toList();
                                            //   }
                                            //   return ListTile(
                                            //     title: Text(e['level1']),
                                            //     subtitle: Text(indexParse.toString()),
                                            //   );
                                            // }).toList(),
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
                  );
                },
                child: Text('${format.format(doc.confirmDate)}', style: textStyle2),
              ),
              // Text(' : ', style: textStyle2),
              // TextButton(
              //   onPressed: () {
              //     Future<DateTime> confrimD = showDatePicker(
              //         context: context,
              //         initialDate: DateTime.now(),
              //         firstDate: DateTime.now().subtract(Duration(days: 365)),
              //         lastDate: DateTime.now().add(Duration(days: 365)));
              //     confrimD.then((value) {
              //       if (value != null) {
              //         setState(() {
              //           doc.confirmDate = value;
              //         });
              //       }
              //     });
              //   },
              //   child: Text('${format.format(doc.confirmDate)}', style: textStyle2),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildConstructTile() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: cardHeight,
          child: Row(
            children: [
              Container(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('공', style: boldText),
                    Text('사', style: boldText),
                    Text('명', style: boldText),
                  ],
                ),
              ),
              Text(' : ', style: textStyle2),
              Text(doc.siteName, style: textStyle2),
            ],
          ),
        ),
      ),
    );
  }

  Card buildRequestDate() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: cardHeight,
          child: Row(
            children: [
              Container(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('요', style: boldText),
                    Text('청', style: boldText),
                    Text('일', style: boldText),
                    Text('자', style: boldText),
                  ],
                ),
              ),
              Text(' : ', style: textStyle2),
              TextButton(
                onPressed: () {
                  Future<DateTime> requestD = showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365)));
                  requestD.then((value) {
                    if (value != null) {
                      setState(() {
                        doc.applyDate = value;
                      });
                    }
                  });
                },
                child: Text('${format.format(doc.applyDate)}', style: textStyle2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildCommandCenter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: cardHeight,
          child: Row(
            children: [
              Container(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('수', style: boldText),
                    Text('신', style: boldText),
                  ],
                ),
              ),
              Text(' : ', style: textStyle2),
              TextButton(
                onPressed: () {
                  setState(() {
                    Get.defaultDialog(
                      title: '수신처를 선택해주세요',
                      content: Container(
                          width: 500,
                          height: 600,
                          child: Column(
                            children: cheifLists
                                .map((e) =>
                                ListTile(
                                  title: Text(e),
                                  onTap: () {
                                    setState(() {
                                      doc.recipient = e;
                                      Get.back();
                                    });
                                  },
                                ))
                                .toList(),
                          )),
                    );
                  });
                },
                child: Text(doc.recipient, style: textStyle2),
              )
            ],
          ),
        ),
      ),
    );
  }

  Card buildDocNum() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: cardHeight,
          child: Row(
            children: [
              Container(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('문', style: boldText),
                    Text('서', style: boldText),
                    Text('번', style: boldText),
                    Text('호', style: boldText),
                  ],
                ),
              ),
              Text(' : ', style: textStyle2),
              Text(doc.docId, style: textStyle2),
            ],
          ),
        ),
      ),
    );
  }
}
