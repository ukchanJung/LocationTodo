import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/data/quailty_data.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app_location_todo/model/doc_confirm_class.dart';
import 'package:get/get.dart';
import 'package:intl/locale.dart';
import 'package:local_auth/local_auth.dart';

class ConfirmPage extends StatefulWidget {
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  TextStyle titleText = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  TextStyle boldText = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  TextStyle textStyle2 = TextStyle(fontSize: 14);
  DateFormat format = DateFormat('yyyy.MM.dd');
  String nullText = '';
  List<CheckList> checkLists;
  ConstructConfirm doc = ConstructConfirm();
  String recepit = '선택해주세요';
  DateTime requestDay = DateTime.now();
  DateTime confirmDay = DateTime.now().add(Duration(days: 1));
  bool _isLocalAuth;
  String _authorized = '서명진행';

  checkBio()async{
    var isLocalAuth;
    isLocalAuth = await LocalAuthentication().canCheckBiometrics;
    setState(() {
      _isLocalAuth = isLocalAuth;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLists = qualityCheckList.map((e) => CheckList.fromMap(e)).toList();
    print(checkLists.length);
    checkBio();
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < 800) {
      return Scaffold(
          appBar: AppBar(
            title: Text('검토'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
            child: Container(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '공사 시공 확인서',
                          style: titleText,
                        ),
                      )
                    ],
                  ),
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
                  buildCheckList(),
                  buildErrorList(),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('첨부 : ', style: textStyle2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    } else if (shortestSide > 800 && shortestSide < 1100) {
      return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.only(left: 54.0, right: 54, bottom: 24, top: 8),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '공사 시공 확인서',
                          style: titleText,
                        ),
                      )
                    ],
                  ),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: buildCheckList(),
                      ),
                      Expanded(
                        child: buildErrorList(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('시공확인이 완료되었으므로 후속공사를 추진하시기 바랍니다.', style: textStyle2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('건설사업관리기술자/공사감독자 :', style: boldText),
                      Container(width: 200, child: Text(nullText, style: textStyle2)),
                      TextButton(onPressed: () {}, child: Text('(sign)', style: textStyle2))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('품질관리자 검사내용', style: boldText),
                    ],
                  ),
                  Expanded(child: Card(child: Container())),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('첨부 : ', style: textStyle2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    }
  }

  Card buildErrorList() {
    return Card(
      child: Container(
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('부적합사항', style: boldText),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Card buildCheckList() {
    return Card(
      child: Container(
        height: 300,
        child: Column(
          children: [
            Container(
              height: 32,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('주요 검사항목(체크리스트)', style: boldText),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
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
                                      children:
                                          checkLists.where((e) => e.type1 == a).map((e) => e.type2).toSet().map((b) {
                                        List<CheckList> f2 = checkLists.where((e) => e.type2 == b).toList();
                                        return ExpansionTile(
                                          title: Text(b),
                                          children: f2
                                              .map((e) => ListTile(
                                                    title: Text(e.timing),
                                                    subtitle: Text(e.checkList),
                                                    onTap: () {
                                                      setState(() {
                                                        doc.checkLists.add(e);
                                                      });
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
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: 10,
            ),
            doc.checkLists != []
                ? Expanded(
                    child: ListView(
                    children: doc.checkLists
                        .map(
                          (e) => CheckboxListTile(
                            title: Text(e.checkList),
                            subtitle: Text(e.timing),
                            controlAffinity: ListTileControlAffinity.leading,
                            // secondary: ElevatedButton.icon(
                            //     onPressed: () {}, icon: Icon(Icons.photo_album), label: Text('첨부파일')),
                            secondary: IconButton(icon: Icon(Icons.photo_album), onPressed: () {}),
                            value: e.check,
                            onChanged: (value) {
                              setState(() {
                                e.check = !e.check;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ))
                : Container()
          ],
        ),
      ),
    );
  }

  Card buildDerectorCheckDays() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: 80,
          child: Row(
            children: [
              Text('공사 감독자의 검사일', style: boldText),
              Text(' : ', style: textStyle2),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          height: 150,
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
                        Text('김ㅇㅇ', style: textStyle2),
                        TextButton(onPressed: () {}, child: Text('(sign)', style: textStyle2))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('2차', style: textStyle2),
                        Text('정ㅇㅇ', style: textStyle2),
                        TextButton(onPressed: () {}, child: Text('(sign)', style: textStyle2))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('3차', style: textStyle2),
                        Text('이ㅇㅇ', style: textStyle2),
                        TextButton(onPressed: () {}, child: Text('(sign)', style: textStyle2))
                      ],
                    ),
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
          height: 150,
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
                        Text('김ㅇㅇ', style: textStyle2),
                        buildSigniture()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('2차', style: textStyle2),
                        Text('정ㅇㅇ', style: textStyle2),
                        buildSigniture()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('3차', style: textStyle2),
                        Text('이ㅇㅇ', style: textStyle2),
                        TextButton(onPressed: () {}, child: Text('(sign)', style: textStyle2))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextButton buildSigniture() {
    return TextButton(onPressed: () {
                        Future<bool> authenticated;
                        authenticated =  LocalAuthentication().authenticateWithBiometrics(localizedReason: '생체인식을 진행해주세요');
                        authenticated.then((value){
                          setState(() {
                          _authorized = value ? '서명완료': '서명실패';
                          });
                        });
                      }, child: Text('${_authorized}', style: textStyle2));
  }

  Card buildCheckBoundary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: 60,
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
              Text('0000011', style: textStyle2),
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
          height: 60,
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
                  Future<DateTime> confrimD = showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365)));
                  confrimD.then((value) {
                    setState(() {
                      confirmDay = value;
                    });
                  });
                },
                child: Text('${format.format(confirmDay)}', style: textStyle2),
              ),
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
          height: 60,
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
              Text('ㅇㅇ공사 ㅇ공구', style: textStyle2),
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
          height: 60,
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
                    setState(() {
                      requestDay = value;
                    });
                  });
                },
                child: Text('${format.format(requestDay)}', style: textStyle2),
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
          height: 60,
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
                            children: doc.recipient
                                .map((e) => ListTile(
                                      title: Text(e),
                                      onTap: () {
                                        setState(() {
                                          recepit = e;
                                          Get.back();
                                        });
                                      },
                                    ))
                                .toList(),
                          )),
                    );
                  });
                },
                child: Text(recepit, style: textStyle2),
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
          height: 60,
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
              Text('0000011', style: textStyle2),
            ],
          ),
        ),
      ),
    );
  }
}
