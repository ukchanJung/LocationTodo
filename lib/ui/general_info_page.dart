import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/data/construc_general_info.dart';
import 'package:flutter_app_location_todo/data/structureJson.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class GeneralInfo extends StatefulWidget {
  List<ConGInfo> infos;

  GeneralInfo(this.infos);

  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  List infodatas;
  bool a = false;
  TextEditingController _textEditingController = TextEditingController();
  List<String> data;
  String aa;
  String search = '일반사항';
  List<String> category;
  List<String> category2;
  List<Map> category3;

  @override
  void initState() {
    super.initState();
    category = widget.infos.map((e) => e.conType).toSet().toList();
    // category2 = widget.infos.map((e) => e.index7).toSet().toList();
    // category3 = widget.infos.map((e) => {'index7':e.index7,'Dif':e.toDif()}).toSet().toList();
    // print(category3);
    // print(category3.length);
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  Color temp(String t) {
    if (t.contains("#")) {
      return Colors.amber;
    } else if (t.contains('@')) {
      return Colors.pinkAccent;
    } else if (t.contains('!')) {
      return Colors.green;
    } else
      Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext ctx) {
        return ListView(
          children: category.map((a){
            List<ConGInfo> subInfo = widget.infos.where((b) => b.conType == a && b.index7 == 'text').toList();
            List<ConGInfo> Test = widget.infos.where((b) => b.conType == a ).toList();
        return ExpansionTile(
          title: Text(a),
          onExpansionChanged: (_){
            print(subInfo);
            print(subInfo.length);
          },
          children: subInfo
              .map(
                (c) {
                  bool _temp = false;
                              List<ConGInfo> _tempG =
                              Test.where((e) => e.toDif() == c.toDif() && e.index7 != 'text').toList();
                              List<String> _tempL = Test
                                  .where((e) => e.toDif() == c.toDif() && e.index7 != 'text')
                                  .map((e) => e.index7)
                                  .toSet()
                                  .toList();
                  return ExpansionTile(
                title: Text(c.toString()),
                children: _temp == true
                    ? [
                        Container(
                          width: 300,
                          height: 300,
                          color: Colors.redAccent,
                        )
                      ]
                    : [
                        Container(
                          child: Image.asset('asset/structure/${c.path}'),
                        ),
                        Wrap(
                          children: _tempL.map((e) {
                            return InkWell(
                              onTap: () {
                                Get.defaultDialog(
                                    content: Container(
                                  height: 800,
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                        children: _tempG
                                            .where((y) => y.index7 == e)
                                            .map((z) => Image.asset(
                                                  'asset/structure/${z.path}',
                                                  height: 270,
                                                ))
                                            .toList()),
                                  ),
                                ));
                              },
                              child: Chip(
                                label: Text(e.substring(1)),
                                backgroundColor: temp(e),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                onExpansionChanged: (_){
                  setState(() {
                  _temp = !_temp;
                  });
                },
              );
            },
          )
              .toList(),
        );
      }).toList()
          // children: category
          //     .map((a) => ExpansionTile(
          //           title: Text(a),
          //           children: widget.infos.where((b) => b.conType == a && b.index7 == 'text').map((c) {
          //             List<ConGInfo> _tempG =
          //                 widget.infos.where((e) => e.toDif() == c.toDif() && e.index7 != 'text').toList();
          //             List<String> _tempL = widget.infos
          //                 .where((e) => e.toDif() == c.toDif() && e.index7 != 'text')
          //                 .map((e) => e.index7)
          //                 .toSet()
          //                 .toList();
          //             return ExpansionTile(
          //               leading: Text('${c.page}p'),
          //               title: Text(c.toString()),
          //               children: [
          //                 Container(
          //                   child: Image.asset('asset/structure/${c.path}'),
          //                 ),
          //                 Wrap(
          //                   children: _tempL.map((e) {
          //                     return InkWell(
          //                       onTap: () {
          //                         Get.defaultDialog(
          //                             content: Container(
          //                           height: 800,
          //                           child: SingleChildScrollView(
          //                             child: Wrap(
          //                                 children: _tempG
          //                                     .where((y) => y.index7 == e)
          //                                     .map((z) => Image.asset(
          //                                           'asset/structure/${z.path}',
          //                                           height: 270,
          //                                         ))
          //                                     .toList()),
          //                           ),
          //                         ));
          //                       },
          //                       child: Chip(
          //                         label: Text(e.substring(1)),
          //                         backgroundColor: temp(e),
          //                       ),
          //                     );
          //                   }).toList(),
          //                 ),
          //               ],
          //             );
          //           }).toList(),
          //         ))
          //     .toList(),
        );
      }
    );
  }
}

class GeneralInfoDetailPage extends StatefulWidget {
  List<ConGInfo> temp ;

  GeneralInfoDetailPage({ this.temp });

  @override
  _GeneralInfoDetailPageState createState() => _GeneralInfoDetailPageState();
}

class _GeneralInfoDetailPageState extends State<GeneralInfoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: widget.temp
            .map(
              (e) => ExpansionTile(
                title: Text(e.toString()),
              ),
            ).toList(),
      ),
    );
  }
}
