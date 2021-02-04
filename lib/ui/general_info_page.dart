import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/data/construc_general_info.dart';
import 'package:flutter_app_location_todo/data/structureJson.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class GeneralInfo extends StatefulWidget {
  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  List<ConGInfo> infos;
  List infodatas;
  bool a = false;
  TextEditingController _textEditingController;
  List<String> data;
  String aa;
  String search = '일반사항';
  List category;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    infos = structureJson.map((e) => ConGInfo.fromMap(e)).toList();
    void readingInfo() async {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      QuerySnapshot read = await _db.collection('generalInfo').get();
      infodatas = read.docs;
      infodatas.forEach((e) {});
      //그리드를 통한 교차점 확인
      //TODO 실시간 연동 바운더리
    }

    // readingInfo();
     category = infos.map((e) => e.conType).toSet().toList();
    print(category);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }
Color temp (String t){
    if(t.contains("#")){
      return Colors.amber;
    }else if(t.contains('@')){
      return Colors.pinkAccent;
    }else if(t.contains('!')){
      return Colors.green;
    } else Colors.grey;
}
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: category.map((c) => ExpansionTile(title: Text(c),
        children: infos.where((t) => t.conType==c&&t.index7=='text')
          .map((e) => ExpansionTile(
        leading: Text('${e.page}p'),
        title: Text(e.toString()),
        children: [
          Container(child: Image.asset('asset/structure/${e.path}'),),
          Wrap(
            children: infos
                .where((c) => c.toString() == e.toString() && c.index7 != 'text')
                .map((e) => Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){Get.defaultDialog(content: Image.asset('asset/structure/${e.path}'));},
                    child: Chip(
                      label: Text(e.index7.substring(1)),
                      backgroundColor: temp(e.index7)
                    ),
                  ),
                )))
                .toList(),
          ),
        ],
      ))
          .toList(),)).toList(),
    );}
  // }  Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('LH핸드북'),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         infos.forEach(print);
  //         setState(() {
  //           data = infodatas
  //               .map((e) =>
  //                   "{'path' : '${e['path']}'},{'fulltext' : '${e['fulltext'].replaceAll(' ', '').replaceAll('\n', '')}'}")
  //               .toList();
  //           a = true;
  //           // _textEditingController.text =infodatas.toString();
  //         });
  //       },
  //     ),
  //     // body: a == false
  //     //   ?Container()
  //     // :Column(
  //     //   children: [
  //     //     Container(
  //     //       height: 100,
  //     //       child: Row(
  //     //         children: [
  //     //           Padding(
  //     //             padding: const EdgeInsets.all(8.0),
  //     //             child: Container(
  //     //               width: 300,
  //     //               height: 80,
  //     //               child: TextField(controller: _textEditingController,
  //     //               ),
  //     //             )
  //     //           ),
  //     //           ElevatedButton(onPressed: (){
  //     //             setState(() {
  //     //               search = _textEditingController.text;
  //     //             });
  //     //           },child: Text('검색'),)
  //     //         ],
  //     //       ),
  //     //     ),
  //     //     Expanded(
  //     //       child: ListView(
  //     //               children: infodatas
  //     //                   .where((e) => e['fulltext'].replaceAll(' ','').contains(search.replaceAll(' ', '')))
  //     //                   .map((t) => Column(
  //     //                 mainAxisSize: MainAxisSize.min,
  //     //                         children: [
  //     //                           ListTile(
  //     //                             title: Text(infos.singleWhere((v) => v.path==t['path']).toString()),
  //     //                           ),
  //     //                           Divider(),
  //     //                           Image.asset('asset/structure/${t['path']}'),
  //     //                           Divider(),
  //     //                         ],
  //     //                       )).toList()
  //     //       ),
  //     //     ),
  //     //   ],
  //     // ),
  //     ///테스트
  //     body: ListView(
  //       children: infos.where((t) => t.index7=='text')
  //           .map((e) => ExpansionTile(
  //                 leading: Text('${e.page}p'),
  //                 title: Text(e.toString()),
  //         children: [
  //           Container(child: Image.asset('asset/structure/${e.path}'),),
  //                   Wrap(
  //                     children: infos
  //                         .where((c) => c.toString() == e.toString() && c.index7 != 'text')
  //                         .map((e) => Container(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: InkWell(
  //                                     onTap: (){Get.defaultDialog(content: Image.asset('asset/structure/${e.path}'));},
  //                                     child: Chip(
  //                                       label: Text(e.index7),
  //                             ),
  //                                   ),
  //                                 )))
  //                         .toList(),
  //                   ),
  //                   // ...infos.where((c) => c.toString() == e.toString() && c.index7 != 'text').map((e) => Card(
  //                   //   child: ExpansionTile(
  //                   //     leading: Text('${e.page.toString()}p'),
  //                   //         title: Text(e.index7),
  //                   //     children: [
  //                   //       Container(child: Image.asset('asset/structure/${e.path}'),),
  //                   //     ],
  //                   //       ),
  //                   // ))
  //                 ],
  //               ))
  //           .toList(),
  //     ),
  //   );
  // }
}
