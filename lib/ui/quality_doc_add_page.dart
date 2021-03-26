import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/work_report_model.dart';
import 'package:flutter_app_location_todo/ui/confirmpage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class QualityCheckDocAddPage extends StatefulWidget {
  @override
  _QualityCheckDocAddPageState createState() => _QualityCheckDocAddPageState();
}

class _QualityCheckDocAddPageState extends State<QualityCheckDocAddPage> {
  List<WorkReport> workReportsDate;
  List<WorkReport> filter;
  DateFormat _format = DateFormat('yyyy.MM.dd');

  @override
  void initState() {
    super.initState();
    workReportsDate = List.generate(30, (index) {
      int _r = Random().nextInt(30);
      DateTime _d = DateTime.now().add(Duration(days: _r));
      return WorkReport(
        title: '작업 $index',
        writeTime: _d,
        modifyTime: _d,
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    filter =workReportsDate..sort((a,b)=>a.writeTime.compareTo(b.writeTime));
    return Scaffold(
      appBar: AppBar(
        title: Text('작업목록'),
      ),
      body: ListView(
        children: filter
            .map(
              (e) => ListTile(
                title: Text(e.title),
                subtitle: Text(_format.format(e.writeTime)),
                onTap: (){
                  Get.defaultDialog(
                    title: e.title,
                    content: Column(children: [
                      ListTile(title: Text(_format.format(e.writeTime)),),
                      e.memo!=null?Text(e.memo):Container()
                    ],),
                    actions:[
                      OutlinedButton(onPressed: (){
                        Get.off(ConfirmPage());
                      }, child: Text('시공확인서 작성')),
                      OutlinedButton(onPressed: (){}, child: Text('닫기')),
                    ]
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
