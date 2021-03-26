import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/doc_confirm_class.dart';
import 'package:flutter_app_location_todo/ui/confirmpage.dart';
import 'package:flutter_app_location_todo/ui/quality_doc_add_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class QualityCheckPage extends StatefulWidget {
  @override
  _QualityCheckPageState createState() => _QualityCheckPageState();
}

class _QualityCheckPageState extends State<QualityCheckPage> {
  List<ConstructConfirm> qLists = [];
  DateTime dDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    void readingGrid() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('docTest').get();
      setState(() {
      qLists = read.docs.map((e) => ConstructConfirm.fromSnapshot(e)).toList();
      });
    }
    readingGrid();

  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(title: Text('LH 스마트 품질 검측'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Get.to(QualityCheckDocAddPage());
          }),
          IconButton(icon: Icon(CommunityMaterialIcons.application_settings), onPressed: (){}),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.play_box), label: '결재 진행중'),
        BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.cancel), label: '반려'),
        BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.view_list), label: '완료'),
      ]),
      body: Column(
        children: [
          Container(
            height: 40,
            width: deviceWidth,
            child: Stack(
              children: [
                Positioned(left:10,child: Container(height:50,child: Center(child: Text('작성일자')))),
                Positioned(left:100,child: Container(height:50,child: Center(child: Text('제목')))),
                Positioned(right:20,child: Container(height:50,child: Center(child: Text('요청일자')))),

              ],
            ),
          ),
          Divider(),
          Expanded(
            child: GestureDetector(
              child: ListView(
                children: qLists
                    .map((ConstructConfirm e) => Container(
                  height: 40,
                      child: ListTile(
                              leading: Container(
                                width: 65,
                                child: Text(
                                  DateFormat('yy.MM.dd').format(e.applyDate),
                                ),
                              ),
                              title: Text(e.toString()),
                              // trailing: Text(timeago.format(e.applyDate.difference(dDay)),),
                              trailing: Text(DateFormat('yy.MM.dd').format(e.confirmDate),),
                              onTap: () {
                                Get.to(ConfirmPage(),arguments: e);
                              },
                            ),
                    ))
                    .toList(),),
            ),
          ),
        ],
      )
    );
  }

  ListTile buildCheckItem({ String title,String check,String zone }) {
    return ListTile(
          title: Text(title),
          subtitle: Text(check),
          leading: Text(zone),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: OutlineButton(
                  onPressed: (){},
                  child: Text('사진 대지'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: OutlineButton(
                  onPressed: (){},
                  child: Text('근로자 명단'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: OutlineButton(
                  onPressed: (){},
                  child: Text('근로계약서'),
                ),
              ),
            ],
          ),
        );
  }
}
